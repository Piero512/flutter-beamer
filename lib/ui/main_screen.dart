import 'package:beamer_app/services/api_service.dart';
import 'package:beamer_app/ui/broadcast_screen.dart';
import 'package:beamer_app/ui/passkey_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Beamer App"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) => PasskeyDialog(),
              ),
              child: Text("Follow location"),
            ),
            SizedBox(
              height: 5,
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      BroadcastScreen(context.watch<ApiService>()),
                ),
              ),
              child: Text("Broadcast location"),
            )
          ],
        ),
      ),
    );
  }
}
