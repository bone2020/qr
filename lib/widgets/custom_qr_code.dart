import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/qr_code_data.dart';
import '../theme/app_theme.dart';

class CustomQRCode extends StatefulWidget {
  final QRCodeData qrData;
  final bool showPrintButton;
  final Function(String)? onQRGenerated;

  const CustomQRCode({
    Key? key,
    required this.qrData,
    this.showPrintButton = true,
    this.onQRGenerated,
  }) : super(key: key);

  @override
  State<CustomQRCode> createState() => _CustomQRCodeState();
}

class _CustomQRCodeState extends State<CustomQRCode> {
  late String _encryptedData;
  final GlobalKey _qrKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _encryptedData = widget.qrData.encryptData();
    widget.onQRGenerated?.call(_encryptedData);
  }

  Future<void> _shareQRCode() async {
    try {
      final RenderRepaintBoundary boundary = _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/qr_code.png').create();
      await file.writeAsBytes(pngBytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'QR Code for ${widget.qrData.amount}',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sharing QR code: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RepaintBoundary(
          key: _qrKey,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.qrData.companyLogo != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Image.network(
                      widget.qrData.companyLogo!,
                      height: 60,
                      width: 60,
                      fit: BoxFit.contain,
                    ),
                  ),
                QrImageView(
                  data: _encryptedData,
                  version: QrVersions.auto,
                  size: 200.0,
                  backgroundColor: Colors.white,
                  embeddedImage: widget.qrData.companyLogo != null
                      ? NetworkImage(widget.qrData.companyLogo!)
                      : null,
                  embeddedImageStyle: QrEmbeddedImageStyle(
                    size: const Size(40, 40),
                  ),
                ),
                const SizedBox(height: 16),
                if (widget.qrData.companyName != null)
                  Text(
                    widget.qrData.companyName!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                const SizedBox(height: 8),
                Text(
                  'Amount: ${widget.qrData.amount}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Purpose: ${widget.qrData.purpose}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (widget.showPrintButton)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ElevatedButton.icon(
              onPressed: _shareQRCode,
              icon: const Icon(Icons.share),
              label: const Text('Share QR Code'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
      ],
    );
  }
} 