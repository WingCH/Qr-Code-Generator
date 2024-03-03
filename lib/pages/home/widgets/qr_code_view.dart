import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeView extends StatelessWidget {
  const QrCodeView({
    super.key,
    required this.qrCodeData,
    this.padding = const EdgeInsets.all(10),
  });

  final String qrCodeData;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return QrImageView(
      data: qrCodeData,
      version: QrVersions.auto,
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      size: 200.0,
      padding: padding,
      dataModuleStyle: QrDataModuleStyle(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
        dataModuleShape: QrDataModuleShape.square,
      ),
      eyeStyle: QrEyeStyle(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
        eyeShape: QrEyeShape.square,
      ),
    );
  }
}
