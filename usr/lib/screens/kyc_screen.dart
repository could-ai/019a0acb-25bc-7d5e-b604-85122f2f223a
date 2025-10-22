import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'dart:io';

class KYCScreen extends StatefulWidget {
  const KYCScreen({super.key});

  @override
  State<KYCScreen> createState() => _KYCScreenState();
}

class _KYCScreenState extends State<KYCScreen> {
  File? _aadhaarImage;
  File? _panImage;
  String _aadhaarText = '';
  String _panText = '';
  bool _isProcessing = false;

  final ImagePicker _picker = ImagePicker();
  final TextRecognizer _textRecognizer = GoogleMlKit.vision.textRecognizer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('KYC Verification')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Upload your Aadhaar and PAN card for verification',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            _buildDocumentUpload(
              'Aadhaar Card',
              _aadhaarImage,
              () => _pickImage(true),
            ),
            const SizedBox(height: 20),
            _buildDocumentUpload(
              'PAN Card',
              _panImage,
              () => _pickImage(false),
            ),
            const SizedBox(height: 20),
            if (_aadhaarText.isNotEmpty) ...[
              const Text('Aadhaar OCR Result:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(_aadhaarText),
              const SizedBox(height: 10),
            ],
            if (_panText.isNotEmpty) ...[
              const Text('PAN OCR Result:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(_panText),
              const SizedBox(height: 10),
            ],
            ElevatedButton(
              onPressed: (_aadhaarImage != null && _panImage != null && !_isProcessing)
                  ? _submitKYC
                  : null,
              child: _isProcessing
                  ? const CircularProgressIndicator()
                  : const Text('Submit KYC'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentUpload(String title, File? image, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: image != null
                ? Image.file(image, fit: BoxFit.cover)
                : const Icon(Icons.camera_alt, size: 50, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage(bool isAadhaar) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        if (isAadhaar) {
          _aadhaarImage = File(image.path);
        } else {
          _panImage = File(image.path);
        }
      });
      _processImage(File(image.path), isAadhaar);
    }
  }

  Future<void> _processImage(File image, bool isAadhaar) async {
    setState(() => _isProcessing = true);
    try {
      final inputImage = InputImage.fromFile(image);
      final recognizedText = await _textRecognizer.processImage(inputImage);
      setState(() {
        if (isAadhaar) {
          _aadhaarText = recognizedText.text;
        } else {
          _panText = recognizedText.text;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OCR failed: $e')),
      );
    }
    setState(() => _isProcessing = false);
  }

  Future<void> _submitKYC() async {
    // Simulate KYC submission
    await Future.delayed(const Duration(seconds: 2));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('KYC submitted successfully!')),
    );
    context.go('/loan-products');
  }

  @override
  void dispose() {
    _textRecognizer.close();
    super.dispose();
  }
}