# 🏋️ Simulador Balança IP

> Aplicativo desktop Windows que emula o protocolo de comunicação de uma **balança industrial Toledo IP**, permitindo testar e desenvolver sistemas de pesagem sem necessidade do hardware físico.

---

## 📋 Para que serve

Balanças industriais Toledo IP transmitem leituras de peso em tempo real via **socket TCP/IP** usando um protocolo de texto proprietário. Integrar um sistema a uma dessas balanças normalmente exige a balança física conectada à rede.

O **Simulador Balança IP** resolve esse problema: ele sobe um servidor TCP na máquina local e transmite mensagens no formato exato do protocolo Toledo para todos os clientes conectados. Com ele é possível:

- **Desenvolver e testar** sistemas de pesagem sem a balança física;
- **Simular oscilação natural** de peso (como o vento, vibração e instabilidade de uma balança real);
- **Configurar limites e casas decimais** para cobrir diferentes modelos de balança;
- **Auditar o protocolo** em tempo real através do histórico de mensagens transmitidas.

---

## 🖥️ Protocolo Toledo IP

Cada mensagem enviada pelo servidor segue o formato:

```
STX + sinal + tipo + peso_bruto + tara + CR
```

| Campo        | Valor               | Detalhe                              |
|--------------|---------------------|--------------------------------------|
| `STX`        | `char(2)`           | Start of Text                        |
| `sinal`      | `+`                 | Sempre positivo nesta implementação  |
| `tipo`       | `p` ou `s`          | `p` = estável, `s` = em movimento    |
| `` ` ``      | literal backtick    | Separador                            |
| `peso_bruto` | 6 dígitos           | Padded com zeros à esquerda          |
| `tara`       | 6 dígitos           | Padded com zeros à esquerda          |
| `CR`         | `char(13)`          | Carriage Return — fim da mensagem    |

**Exemplo:** `\x02+p\`000500000000\r` → peso 500g, tara 0g, estável.

> O histórico exibe `{2}` e `{13}` no lugar dos caracteres de controle para facilitar a leitura.

---

## 🏗️ Arquitetura

O projeto segue **Clean Architecture** com separação em dois domínios principais e três camadas por domínio.

```
lib/
├── main.dart                        # Bootstrap: DI, BLoCs, tema, janela
├── splash_page.dart                 # Tela de splash adaptativa ao tema do sistema
├── theme_manager.dart               # ThemeNotifier (Provider) para modo claro/escuro
├── core/                            # Abstrações e casos de uso genéricos
│   ├── error/
│   ├── theme/
│   └── usecases/
├── Utils/                           # Helpers transversais
│   └── shared_preferences_helper.dart
├── widgets/                         # Widgets globais reutilizáveis
│   ├── my_drawer_menu.dart          # Menu lateral (seletor de tema)
│   ├── show_dialog_custom.dart
│   └── textformfiled.dart
└── features/
    ├── scale_backend/               # Domínio: Servidor TCP
    │   ├── domain/
    │   │   ├── entities/scale_protocol.dart
    │   │   ├── formatters/protocol_strategy.dart   # Padrão Strategy para formatação
    │   │   └── repositories/scale_server_repository.dart
    │   ├── data/
    │   │   └── repositories/scale_server_repository_impl.dart
    │   └── presentation/
    │       └── bloc/scale_backend_bloc.dart        # Gerencia estado do servidor
    └── scale_frontend/              # Domínio: Interface do operador
        ├── domain/
        │   ├── entities/scale_config.dart          # Porta, MinMax, Casas decimais
        │   └── repositories/scale_config_repository.dart
        ├── data/
        │   └── repositories/scale_config_repository_impl.dart  # Persiste via SharedPreferences
        └── presentation/
            ├── bloc/
            │   ├── config_bloc/     # Carrega/salva configurações
            │   └── weight_bloc/     # Peso, tara e oscilação
            ├── pages/               # Página principal
            └── widgets/
                ├── config_panel.dart   # Painel de configuração expansível
                ├── weight_panel.dart   # Controle de peso e oscilação
                └── log_panel.dart      # Histórico de mensagens enviadas
```

### Fluxo de dados

```
[Operador ajusta peso]
        │
        ▼
  WeightBloc (peso, tara, oscilação)
        │
        ▼
  ScaleBackendBloc  ──►  broadcastMessage()
        │                       │
        ▼                       ▼
 ScaleBackendState        ServerSocket (0.0.0.0:porta)
  (ip, porta, history)          │
        │                       ▼
        ▼               Todos os clientes TCP conectados
     LogPanel                  recebem a string do protocolo
```

---

## ⚙️ Gerenciamento de estado

| BLoC               | Responsabilidade                                                  |
|--------------------|-------------------------------------------------------------------|
| `ScaleBackendBloc` | Iniciar/parar o servidor TCP, receber histórico de mensagens     |
| `WeightBloc`       | Peso manual, tara, oscilação periódica (timer a cada 300ms)      |
| `ConfigBloc`       | Carregar e salvar `ScaleConfig` via `SharedPreferences`          |
| `ThemeNotifier`    | Alternar entre modo claro e escuro (Provider)                    |

---

## 🔌 Servidor TCP

- **Bind:** `0.0.0.0` (qualquer interface IPv4) — aceita conexões de qualquer cliente na rede local.
- **IP exibido na UI:** Detectado automaticamente entre as interfaces disponíveis, priorizando adaptadores físicos e depriorizando VPN, WSL, VirtualBox e adaptadores virtuais.
- **Múltiplos clientes:** Suporta N clientes simultâneos. Cada `broadcastMessage()` escreve para todos os sockets ativos.
- **Histórico:** Mantém as últimas 100 mensagens em memória, disponibilizadas via `Stream` para o `LogPanel`.

### Seleção do IP de exibição

```
interfaces → ordena (físicos antes de virtuais)
           → filtra: IPv4, não-loopback, não link-local
           → primeiro resultado = IP exibido na UI
```

---

## 🎛️ Funcionalidades da interface

### Painel de Peso (`WeightPanel`)
- Slider ou campo numérico para definir o peso base
- Campo de tara
- **Modo oscilação:** timer a cada 300ms gera um peso aleatório dentro do intervalo `[base - variância, base + variância]`, simulando a instabilidade de uma balança real
- Protocolo Strategy permite adicionar novos formatos no futuro

### Painel de Configuração (`ConfigPanel`)
- **Card de conexão** (sempre visível): botão Conectar/Desconectar, IP e porta exibidos
- **Expander Adwaita** (collapsa automaticamente ao conectar):
  - Porta TCP (padrão: `32211`)
  - Valor máximo de peso (MinMax)
  - Número de casas decimais
  - Botão para aplicar protocolo
  - Botão para aplicar limites

### Painel de Log (`LogPanel`)
- Lista rolável das últimas 100 mensagens transmitidas
- Caracteres de controle exibidos como `{2}` e `{13}` para legibilidade

### Menu lateral
- Alternância entre tema claro e escuro
- Segue o padrão visual GNOME/Adwaita

---

## 🎨 Design e UI

- **Design System:** [libadwaita](https://pub.dev/packages/libadwaita) — componentes visuais no padrão GNOME/Adwaita (fork local em `packages/libadwaita`)
- **Tema dinâmico:** [`dynamic_color`](https://pub.dev/packages/dynamic_color) — adapta a cor de acento ao tema do sistema operacional (Material You / Windows accent color)
- **Janela customizada:** [`bitsdojo_window`](https://pub.dev/packages/bitsdojo_window) — barra de título e bordas nativas Adwaita (sem barra padrão do Windows)
- **Tamanho inicial:** 1000×700px | Mínimo: 400×600px
- **Cards:** bordas arredondadas (12px), `elevation: 0`, borda com opacidade 8%
- **Botões de ação:** largura fixa de 160px para alinhamento visual uniforme

---

## 📦 Dependências principais

| Pacote                  | Uso                                              |
|-------------------------|--------------------------------------------------|
| `flutter_bloc`          | Gerenciamento de estado (BLoC pattern)           |
| `equatable`             | Comparação de estados e eventos imutáveis        |
| `provider`              | ThemeNotifier (estado de tema global)            |
| `shared_preferences`    | Persistência de configurações entre sessões      |
| `libadwaita` (local)    | Componentes visuais GNOME/Adwaita                |
| `dynamic_color`         | Cor de acento dinâmica do sistema                |
| `bitsdojo_window`       | Controle nativo da janela Windows                |
| `package_info_plus`     | Versão do app na interface                       |
| `easy_splash_screen`    | Tela de splash inicial                           |

---

## 🛠️ Requisitos de desenvolvimento

| Ferramenta        | Versão mínima |
|-------------------|---------------|
| Flutter           | `≥ 3.35.0`   |
| Dart SDK          | `≥ 3.6.0`    |
| FVM               | Recomendado (`.fvmrc` incluso no projeto)       |
| Windows           | Build target principal                          |
| Inno Setup 6      | Necessário para gerar o instalador              |

---

## 🚀 Como executar

```bash
# Clonar e instalar dependências
flutter pub get

# Rodar em modo debug
flutter run -d windows

# Build de produção
flutter build windows --release

# Gerar instalador (requer Inno Setup 6 instalado)
dart instalador/build_installer.dart
```

O instalador é gerado em `instalador/Output/Instalador Simulador de Balanca.exe`.

---

## 💡 Dica para desenvolvedores

Para visualizar corretamente os `#region` definidos nos arquivos Dart no VS Code, instale a extensão:

> **[#region folding for VS Code](https://marketplace.visualstudio.com/items?itemName=maptz.regionfolder)**

---

## 📄 Licença

Projeto privado — uso interno. Não publicado no pub.dev (`publish_to: none`).
