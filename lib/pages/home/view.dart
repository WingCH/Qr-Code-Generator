import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _qrCodeData = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.8,
          heightFactor: 1,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              QrImage(
                data: _qrCodeData,
                version: QrVersions.auto,
                size: 200.0,
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Enter a string',
                ),
                onChanged: (value) {
                  setState(() {
                    _qrCodeData = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('History', style: Theme.of(context).textTheme.headline6),
                  const SizedBox(height: 8),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: [
                      InputChip(
                        label: Text('Generate'),
                        onDeleted: () {
                          setState(() {
                            _qrCodeData = '';
                          });
                        },
                        onPressed: () {
                          setState(() {
                            _qrCodeData = 'Hello, world!';
                          });
                        },
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
