import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'widgets/qr_code_view.dart';

class ScreenshotCaptureView extends StatelessWidget {
  const ScreenshotCaptureView({
    super.key,
    required this.qrCodeData,
    required this.qrCodeColor,
  });

  final String qrCodeData;
  final Color qrCodeColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 216,
      color: Theme.of(context).colorScheme.onPrimary,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QrCodeView(
              qrCodeData: qrCodeData,
              padding: const EdgeInsets.all(0),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 24,
              child: AutoSizeText(
                qrCodeData,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
                maxLines: 5,
                minFontSize: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
