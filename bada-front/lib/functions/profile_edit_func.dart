import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

class ProfileEditFunc {
  Future<String> compressImage(String imagePath, {int quality = 10}) async {
    // 이미지 파일을 읽습니다.
    File originalImageFile = File(imagePath);
    List<int> imageBytes = await originalImageFile.readAsBytes();

    Uint8List imageBytesUint8 = Uint8List.fromList(imageBytes);
    img.Image image = img.decodeImage(imageBytesUint8)!;

    // 품질을 조정하여 이미지를 압축합니다.
    List<int> compressedImageBytes = img.encodeJpg(image, quality: quality);

    // 압축된 이미지를 원본 파일과 같은 경로에 저장하거나 새 경로를 지정할 수 있습니다.
    await originalImageFile.writeAsBytes(compressedImageBytes);

    return originalImageFile.path;
  }
}
