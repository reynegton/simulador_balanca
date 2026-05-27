import 'dart:io';

void main() async {
  // Quando rodado via 'dart instalador/build_installer.dart' a partir da raiz,
  // Directory.current já é a raiz do projeto.
  final projectRoot = Directory.current.path;
  final instaladorDir = '$projectRoot\\instalador';

  print('=== Simulador Balança - Build do Instalador ===');
  print('Raiz do projeto: $projectRoot');
  print('Pasta instalador: $instaladorDir\n');

  // --- 1. Lê a versão do pubspec.yaml ---
  final pubspecFile = File('$projectRoot\\pubspec.yaml');
  String appVersion = '1.0.0';
  if (pubspecFile.existsSync()) {
    for (final line in pubspecFile.readAsLinesSync()) {
      if (line.startsWith('version:')) {
        appVersion = line.split(':')[1].trim();
        // Remove o build number (ex: +1) para o instalador
        if (appVersion.contains('+')) {
          appVersion = appVersion.split('+')[0];
        }
        break;
      }
    }
  }
  print('Versão detectada: $appVersion\n');

  // --- 2. Flutter build windows ---
  print('--- Etapa 1/2: Flutter build windows ---');
  final buildProcess = await Process.start(
    'fvm',
    ['flutter', 'build', 'windows', '--release'],
    workingDirectory: projectRoot,
    runInShell: true,
    mode: ProcessStartMode.inheritStdio, // herda stdin/stdout/stderr do pai
  );

  final buildExitCode = await buildProcess.exitCode;
  if (buildExitCode != 0) {
    print('\nERRO: Flutter build falhou (código: $buildExitCode). Abortando.');
    exit(1);
  }
  print('\nBuild do Flutter concluído com sucesso!\n');

  // --- 3. Verifica Inno Setup ---
  final innoSetupPath = r'C:\Program Files (x86)\Inno Setup 6\ISCC.exe';
  if (!File(innoSetupPath).existsSync()) {
    print('ERRO: Inno Setup não encontrado em: $innoSetupPath');
    print('Instale o Inno Setup 6 e tente novamente.');
    exit(1);
  }

  // --- 4. Gera o instalador com Inno Setup ---
  print('--- Etapa 2/2: Gerando instalador (versão $appVersion) ---');
  final innoProcess = await Process.start(
    innoSetupPath,
    [
      '/O$instaladorDir\\Output',
      '/DMyAppVersion=$appVersion',
      '$instaladorDir\\instalador.iss'
    ],
    workingDirectory: instaladorDir,
    runInShell: false,
    mode: ProcessStartMode.inheritStdio,
  );

  final innoExitCode = await innoProcess.exitCode;
  if (innoExitCode == 0) {
    print('\n=== Sucesso! ===');
    print('Instalador gerado em: $instaladorDir\\Output\\');
  } else {
    print('\nERRO: Inno Setup falhou (código: $innoExitCode).');
    exit(1);
  }
}
