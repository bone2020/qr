import 'package:flutter/material.dart';
import '../screens/generate_qr_screen.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:convert';

class ScanqrcodePageWidget extends StatefulWidget {
  const ScanqrcodePageWidget({super.key});

  static String routeName = 'ScanqrcodePage';
  static String routePath = '/scanqrcodePage';

  @override
  State<ScanqrcodePageWidget> createState() => _ScanqrcodePageWidgetState();
}

class _ScanqrcodePageWidgetState extends State<ScanqrcodePageWidget> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isScanning = true;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        isScanning = _tabController.index == 0;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null) {
        try {
          final data = jsonDecode(scanData.code!);
          _handleQRCodeData(data);
        } catch (e) {
          _showError('Invalid QR code format');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('QR Code'),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Scan QR'),
              Tab(text: 'Generate QR'),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            // Scan QR Tab
            Stack(
              children: [
                QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                    borderColor: Theme.of(context).primaryColor,
                    borderRadius: 10,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: MediaQuery.of(context).size.width * 0.8,
                  ),
                ),
                Positioned(
                  bottom: 24,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          isScanning ? Icons.flash_off : Icons.flash_on,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          await controller?.toggleFlash();
                          setState(() {
                            isScanning = !isScanning;
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.flip_camera_ios,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          await controller?.flipCamera();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Generate QR Tab
            const GenerateQRScreen(),
          ],
        ),
      ),
    );
  }

  void _handleQRCodeData(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('QR Code Detected'),
        content: Text('Amount: GHS ${data['amount']}\nDescription: ${data['description']}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                '/payment',
                arguments: data,
              );
            },
            child: const Text('Proceed'),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
