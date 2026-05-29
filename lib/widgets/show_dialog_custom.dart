import 'package:flutter/material.dart';
import 'package:adwaita_flutter/adwaita_flutter.dart';

Future showDialogCustom({
  required BuildContext context,
  String title = "Aviso",
  String nomeButton = 'Confirmar',
  String nomeButtonCancelar = 'Cancelar',
  double height = double.minPositive,
  required String msg,
  int maxLine = 3,
  bool exibirCancelar = false,
  void Function()? onPressed,
  void Function()? onPressedButtonCancelar,
}) async {
  await showDialog(
    context: context,
    builder: (context) {
      final theme = Theme.of(context);
      final contentStyle = theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
      );
      final contentWidget = Text(
        msg,
        textAlign: TextAlign.center,
        maxLines: maxLine,
        overflow: TextOverflow.ellipsis,
        style: contentStyle,
      );
      return AlertDialog(
        title: Text(
          title,
          style: theme.textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        content: height == double.minPositive
            ? contentWidget
            : SizedBox(
                height: height,
                child: Align(
                  alignment: Alignment.center,
                  child: contentWidget,
                ),
              ),
        actionsAlignment: MainAxisAlignment.center,
        actions: <Widget>[
          if (exibirCancelar)
            AdwButton(
              onPressed: onPressedButtonCancelar ??
                  () {
                    Navigator.of(context).pop();
                  },
              child: Text(nomeButtonCancelar),
            ),
          AdwButton(
            backgroundColor: Theme.of(context).colorScheme.primary,
            textStyle:
                TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            opaque: true,
            onPressed: onPressed ??
                () {
                  Navigator.of(context).pop();
                },
            child: Text(nomeButton),
          ),
        ],
      );
    },
    barrierDismissible: false,
  );
}
