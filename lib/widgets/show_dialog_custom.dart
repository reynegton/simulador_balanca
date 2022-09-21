import 'package:flutter/material.dart';

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
      return AlertDialog(
        title: Text(
          title,
          style: const TextStyle(fontSize: 14),
          textAlign: TextAlign.center,
        ),
        content: height == double.minPositive
            ? Text(
                msg,
                textAlign: TextAlign.center,
                maxLines: maxLine,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                ),
              )
            : Container(
                height: height,
                alignment: Alignment.center,
                child: Text(
                  msg,
                  textAlign: TextAlign.center,
                  maxLines: maxLine,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                ),
              ),
        actionsAlignment: MainAxisAlignment.center,
        actions: <Widget>[
          exibirCancelar
              ? ElevatedButton(
                  onPressed: onPressedButtonCancelar ??
                      () {
                        Navigator.of(context).pop();
                      },
                  child: Text(
                    nomeButtonCancelar,
                  ),
                )
              : const SizedBox.shrink(),
          ElevatedButton(
            onPressed: onPressed ??
                () {
                  Navigator.of(context).pop();
                },
            child: Text(
              nomeButton,
            ),
          ),
        ],
      );
    },
    barrierDismissible: false,
  );
}
