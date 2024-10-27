import 'dart:io';

import 'package:cstore/Database/db_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import '../../../Network/app_exceptions.dart';
import '../toast/toast.dart';
import 'package:image/image.dart' as img;


Future<void> saveDbFile(BuildContext context,String dbName) async {
  try {
    final PermissionStatus permissionStatus = await _getPermission();

    if (permissionStatus == PermissionStatus.granted) {

      final String dirPath = (await getExternalStorageDirectory())!.path;
      final String folderPath = '$dirPath/cstore/database';

      final String filePath = '$folderPath/$dbName';
      final Directory folder = Directory(folderPath);

      const databaseName = 'cstore_pro.db';
      var databasesPath = await getDatabasesPath();

      await DatabaseHelper.closeDb('$databasesPath/$databaseName');

      if (await folder.exists()) {
        await File('$databasesPath/$databaseName').copy(filePath).then((value) {
          showAnimatedToastMessage(
              "Success", "Database stored successfully".tr, true);
        });
      } else {
        await Directory(folderPath).create(recursive: true);
        await File('$databasesPath/$databaseName').copy(filePath).then((value) {
          showAnimatedToastMessage(
              "Success", "Database stored successfully".tr, true);
        });
      }
    } else {
      showAnimatedToastMessage("Success", "Permission denied".tr, false);
    }
  } catch (e) {
    print("Error while saving DB");
    print(e.toString());
  }
}

Future<void> takePicture(BuildContext context, File? imageFile,
    String imageName, String visitId, String moduleName) async {
  try{
    if (Platform.isAndroid) {
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

          if (mb >= 6) {
            compressedImageFile =
                await testCompressAndGetFile(imageFile, targetPath, 50);
          } else if (mb < 6 && mb > 4) {
            compressedImageFile =
                await testCompressAndGetFile(imageFile, targetPath, 65);
          } else if (mb < 4 && mb > 2) {
            compressedImageFile =
                await testCompressAndGetFile(imageFile, targetPath, 80);
          } else {
            compressedImageFile =
                await testCompressAndGetFile(imageFile, targetPath, 80);
          }

          //Image Compress Function call
          compressedWaterMarkImageFile = await addWatermark(
              compressedImageFile, DateTime.now().toString());

          print("__________________FIle Details________________");
          print(mb);
          print(dirPath);
          print(filePath);
          print(imageName);
          print(compressedWaterMarkImageFile.path);
          print(imageFile.lengthSync());
          print(await compressedWaterMarkImageFile.length());
          print("__________________FIle Details________________");

          bool isImageCorruptedStatus = await isImageCorrupted(compressedWaterMarkImageFile);

          if(isImageCorruptedStatus)
          {
            throw FetchDataException("Something is Wrong with image please take the image again".tr);
          }

          if (await folder.exists()) {
            await File(compressedWaterMarkImageFile.path)
                .copy(filePath)
                .then((value) {
              // ToastMessage.succesMessage(context, "Image store successfully");
            });
          } else {
            await Directory(folderPath).create(recursive: true);
            await File(compressedWaterMarkImageFile.path)
                .copy(filePath)
                .then((value) {
              // ToastMessage.succesMessage(context, "Image store successfully");
            });
          }

          // setState(() {
          //   imageFile = File(filePath);
          // });
        }
      } else {
        // print('Permission denied');
        ToastMessage.errorMessage(context, "Permission denied".tr);
      }
    } else if (Platform.isIOS) {
      final PermissionStatus permissionStatus = await _getStoragePermission();
      XFile compressedImageFile;
      XFile compressedWaterMarkImageFile;
      if (permissionStatus == PermissionStatus.granted) {
        if (imageFile != null) {
          final String dirPath =
              (await getApplicationDocumentsDirectory()).path;
          final String folderPath = '$dirPath/cstore/$visitId/$moduleName';

          final String filePath = '$folderPath/$imageName';
          final Directory folder = Directory(folderPath);

          //Image Compress Function call
          final dir = await getTemporaryDirectory();
          final targetPath = path.join(dir.path, imageName);

          int sizeInBytes = imageFile.readAsBytesSync().lengthInBytes;
          final kb = sizeInBytes / 1024;
          final mb = kb / 1024;

          if (mb >= 6) {
            compressedImageFile =
                await testCompressAndGetFile(imageFile, targetPath, 50);
          } else if (mb < 6 && mb > 4) {
            compressedImageFile =
                await testCompressAndGetFile(imageFile, targetPath, 65);
          } else if (mb < 4 && mb > 2) {
            compressedImageFile =
                await testCompressAndGetFile(imageFile, targetPath, 80);
          } else {
            compressedImageFile =
                await testCompressAndGetFile(imageFile, targetPath, 80);
          }

          //Image Compress Function call
          compressedWaterMarkImageFile = await addWatermark(
              compressedImageFile, DateTime.now().toString());

          print("__________________FIle Details________________");
          print(mb);
          print(dirPath);
          print(filePath);
          print(imageName);
          print(compressedWaterMarkImageFile.path);
          print(imageFile.lengthSync());
          print(await compressedWaterMarkImageFile.length());
          print("__________________FIle Details________________");

          bool isImageCorruptedStatus = await isImageCorrupted(compressedWaterMarkImageFile);

          if(isImageCorruptedStatus)
            {
              throw FetchDataException("Something is Wrong with image please take the image again".tr);
            }

          if (await folder.exists()) {
            await File(compressedWaterMarkImageFile.path)
                .copy(filePath)
                .then((value) {
              // ToastMessage.succesMessage(context, "Image store successfully");
            });
          } else {
            await Directory(folderPath).create(recursive: true);
            await File(compressedWaterMarkImageFile.path)
                .copy(filePath)
                .then((value) {
              // ToastMessage.succesMessage(context, "Image store successfully");
            });
          }

          // setState(() {
          //   imageFile = File(filePath);
          // });
        }
      } else {
        // print('Permission denied');
        ToastMessage.errorMessage(
            context,
            "Permission"
                    " denied"
                .tr);
      }
    }
  } catch (e) {
    print(e.toString());
    showAnimatedToastMessage("Error!".tr, "Something went wrong plz try again later", false);
  }
}

Future<PermissionStatus> _getPermission() async {
  final PermissionStatus permission = await Permission.camera.request();
  return permission;
}

Future<PermissionStatus> _getStoragePermission() async {
  final PermissionStatus permission = await Permission.camera.request();
  return permission;
}

Future<XFile> testCompressAndGetFile(File file, String targetPath,int compressQuality) async {

  try {
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
  } catch (e) {
    print(e.toString());
    showAnimatedToastMessage("Error!".tr, "Image Compression error", false);
    return XFile(file.path);
  }
}

///Adding Watermark on image
Future<XFile> addWatermark(XFile compressedFile, String watermarkText) async {
  // Read the image from the file
  try {
    img.Image? image = img.decodeImage(await compressedFile.readAsBytes());
    String updatedMark =
        DateFormat("yyyy/MM/dd - HH:mm").format(DateTime.parse(watermarkText));
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
  } catch (e) {
    print(e.toString());
    showAnimatedToastMessage("Error!".tr, "Image Time addition error", false);
    return XFile(compressedFile.path);
  }
}

///IS Image Courrpt or any issue with image
Future<bool> isImageCorrupted(XFile imageFile) async {
  try {
    // Read the image file
    final imageBytes = await imageFile.readAsBytes();

    // Attempt to decode the image
    final decodedImage = img.decodeImage(imageBytes);

    // Check if decoding was successful
    return decodedImage == null; // Returns true if the image is corrupted
  } catch (e) {
    print("Error reading image file: ${e.toString()}");
    return true; // Treat any exception as a sign of corruption
  }
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
