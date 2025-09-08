import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

RxBool isUserLogged = true.obs;
const String fromSignUp = "FromSignUp";
const String fromLogin = "FromLogin";
const String firstTimePref = "firstTime";
const int flushbarDuration = 3; // in seconds

typedef ProgressCallback = void Function(double progress);


// Run compression in an isolate (Background Thread)
Future<Map<String, dynamic>> compressImage(String filePath) async {
  File file = File(filePath);

  // original file size
  int originalSize = await file.length();
  double originalSizeKB = originalSize / 1024;
  double originalSizeMB = originalSizeKB / 1024;
  log(
    'Original file size: ${originalSizeKB.toStringAsFixed(2)} KB (${originalSizeMB.toStringAsFixed(2)} MB)',
  );

  List<int> imageBytes = await file.readAsBytes();
  img.Image? image = img.decodeImage(Uint8List.fromList(imageBytes));

  if (image != null) {
    // Resizing image
    image = img.copyResize(image, width: 800);

    // Reducing image quality
    List<int> compressedBytes = img.encodeJpg(image, quality: 70);

    // compressed file size
    int compressedSize = compressedBytes.length;
    double compressedSizeKB = compressedSize / 1024;
    double compressedSizeMB = compressedSizeKB / 1024;
    log(
      'Compressed file size: ${compressedSizeKB.toStringAsFixed(2)} KB (${compressedSizeMB.toStringAsFixed(2)} MB)',
    );

    // Converting to base64
    String base64String = base64Encode(compressedBytes);
    String fileName = filePath.split('/').last;

    return {"fileName": fileName, "uploadBytes": base64String};
  }
  return {};
}

Future<List<String>> encodeImagesToBase64(List<String> imagePaths) async {
  List<String> base64Images = [];

  for (String path in imagePaths) {
    File imageFile = File(path);
    List<int> imageBytes = await imageFile.readAsBytes();
    String base64String = base64Encode(imageBytes);
    base64Images.add(base64String);
  }

  return base64Images;
}

Uint8List? base64ToImage(String base64String) {
  try {
    return base64Decode(base64String);
  } catch (e) {
    print("Error decoding Base64: $e");
    return null;
  }
}

Future<File> decodeBase64ToFile(String base64String, String outputPath) async {
  List<int> imageBytes = base64Decode(base64String);
  File imageFile = File(outputPath);
  await imageFile.writeAsBytes(imageBytes);
  return imageFile;
}

Color getStatusColor(String? status) {
  switch (status?.toLowerCase()) {
    case 'draft':
      return Colors.grey.shade600; // Grey for draft
    case 'pending':
      return Colors.orange.shade600; // Orange for pending
    case 'approved':
      return Colors.green.shade600; // Green for approved
    case 'rejected':
      return Colors.red.shade600; // Red for rejected
    default:
      return Colors
          .blueGrey
          .shade400; // Default color for null or unknown status
  }
}

Future<DateTime?> selectDate(
  BuildContext context,
  DateTime? lastDate, {
  DateTime? initialDate,
}) async {
  return await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: DateTime(2000),
    lastDate: lastDate ?? DateTime.now(),
  );
}

double addTax(String value, double percentage) {
  double amount = double.tryParse(value) ?? 0.0;

  double taxAmount = (amount * percentage) / 100;
  return amount + taxAmount;
}

double calculateTaxAmount(String value, double percentage) {
  double amount = double.tryParse(value) ?? 0.0;

  double taxAmount = (amount * percentage) / 100;
  return taxAmount;
}

enum MessageType { text, image, document }
