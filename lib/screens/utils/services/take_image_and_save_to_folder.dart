import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import '../toast/toast.dart';
import 'package:image/image.dart' as img;

Future<void> takePicture(BuildContext context, File? imageFile,
    String imageName, String visitId, String moduleName) async {
  final PermissionStatus permissionStatus = await _getPermission();
  XFile compressedImageFile;
  XFile compressedWaterMarkImageFile;
  if (permissionStatus == PermissionStatus.granted) {
    if (imageFile != null) {
      final String dirPath = (await getExternalStorageDirectory())!.path;
      final String folderPath = '$dirPath/cstore/$visitId/$moduleName';

      final String filePath = '$folderPath/$imageName';
      final Directory folder = Directory(folderPath);

      //Image Compress Function call
      final dir = await getTemporaryDirectory();
      final targetPath = path.join(dir.path, imageName);

      int sizeInBytes = imageFile.readAsBytesSync().lengthInBytes;
      final kb = sizeInBytes / 1024;
      final mb = kb / 1024;

      if(mb >= 6) {
        compressedImageFile = await testCompressAndGetFile(imageFile, targetPath,50);
      } else if(mb < 6 && mb > 4) {
        compressedImageFile = await testCompressAndGetFile(imageFile, targetPath,65);
      } else if(mb < 4 && mb > 2) {
        compressedImageFile = await testCompressAndGetFile(imageFile, targetPath,80);
      } else {
        compressedImageFile = await testCompressAndGetFile(imageFile, targetPath,100);
      }

      //Image Compress Function call
      compressedWaterMarkImageFile = await addWatermark(compressedImageFile, DateTime.now().toString());

      print("__________________FIle Details________________");
      print(mb);
      print(dirPath);
      print(filePath);
      print(imageName);
      print(compressedWaterMarkImageFile.path);
      print(imageFile.lengthSync());
      print(await compressedWaterMarkImageFile.length());
      print("__________________FIle Details________________");

      if (await folder.exists()) {
        await File(compressedWaterMarkImageFile.path).copy(filePath).then((value) {
          // ToastMessage.succesMessage(context, "Image store successfully");
        });
      } else {
        await Directory(folderPath).create(recursive: true);
        await File(compressedWaterMarkImageFile.path).copy(filePath).then((value) {
          // ToastMessage.succesMessage(context, "Image store successfully");
        });
      }

      // setState(() {
      //   imageFile = File(filePath);
      // });
    }
  } else {
    // print('Permission denied');
    ToastMessage.errorMessage(context, "Permissing denied");
  }
}

Future<PermissionStatus> _getPermission() async {
  final PermissionStatus permission = await Permission.camera.request();
  return permission;
}

Future<XFile> testCompressAndGetFile(File file, String targetPath,int compressQuality) async {
  XFile? result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path, targetPath,
      minWidth: 700, minHeight: 700, quality: compressQuality);

  final bytes = await file.length();
  final kb = bytes / 1024;

  final bytes1 = await result!.length();
  final kb1 = bytes1 / 1024;

  print("Files Sizes");
  print("Main File: $kb");
  print("Compressed File: $kb1");

  if (result == null) {
    print("Image compression failed");
    return XFile(file.path);
  } else {
    print("Image compressed successfully");
    return result;
  }
}

///Adding Watermark on image
Future<XFile> addWatermark(XFile compressedFile, String watermarkText) async {
  // Read the image from the file
  img.Image? image = img.decodeImage(await compressedFile.readAsBytes());
  String updatedMark = DateFormat("yyyy/MM/dd - HH:mm").format(DateTime.parse(watermarkText));
  if (image == null) {
    throw Exception("Unable to decode image");
  }

  // Position of the watermark (bottom-left corner with padding)

  final x = 0;
  final y = image.height - 50;

  // Define the watermark text
  img.drawString(
    image,
    img.arial_24,
    x,
    y,
    updatedMark,
    color: img.getColor(255, 226, 226, 226),
  );
  // Get the temporary directory to save the watermarked image
  final Directory tempDir = await getTemporaryDirectory();
  String targetPath = '${tempDir.path}/watermarked_${compressedFile.name}';

  // Save the watermarked image to a file
  final watermarkedFile = File(targetPath);
  watermarkedFile.writeAsBytesSync(img.encodeJpg(image));

  print('WaterMark Added $updatedMark');

  return XFile(watermarkedFile.path);
}


///Delete Folder From local phone

Future<void> deleteFolder(String workingId) async {
  try {
    final String dirPath = (await getExternalStorageDirectory())!.path;
    final String folderPath = '$dirPath/cstore/$workingId';
    final Directory directory = Directory(folderPath);

    if (await directory.exists()) {
      await directory.delete(recursive: true);
      print("Folder deleted successfully");
    } else {
      print("Folder does not exist");
    }
  } catch (e) {
    print("Error while deleting folder: $e");
  }
}
