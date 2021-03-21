import 'dart:math';

import 'package:beamer_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';
import 'follow_screen.dart';

class PasskeyDialog extends StatefulWidget {
  @override
  _PasskeyDialogState createState() => _PasskeyDialogState();
}

class _PasskeyDialogState extends State<PasskeyDialog> {
  TextEditingController _passkeyController = TextEditingController();
  final uuidRegex = RegExp(
      r"[0-9A-F]{8}-?[0-9A-F]{4}-?[0-9A-F]{4}-?[0-9A-F]{4}-?[0-9A-F]{12}",
      caseSensitive: false);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            Text("Please enter the passkey you want to follow"),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: (input) => Uuid.isValidUUID(input)
                          ? null
                          : "Please write a valid UUID",
                      inputFormatters: [FilteringTextInputFormatter.deny("\s")],
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _passkeyController,
                      decoration: InputDecoration(labelText: "Passkey"),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.content_paste),
                  onPressed: () {
                    Clipboard.getData("text/plain").then(
                      (value) {
                        if (uuidRegex.hasMatch(value.text)) {
                          _passkeyController.text =
                              uuidRegex.firstMatch(value.text).group(0);
                        } else {
                          _passkeyController.text = value.text
                              .substring(0, min(value.text.length, 35));
                        }
                      },
                    );
                  },
                )
              ],
            ),
            ButtonBar(
              children: [
                TextButton(
                  child: Text("Confirm"),
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FollowScreen(
                        passkey: _passkeyController.text,
                        service: context.read<ApiService>(),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
