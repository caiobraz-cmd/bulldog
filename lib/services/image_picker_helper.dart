import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

class ImagePickerHelper {
  // Função que abre o seletor de arquivo e retorna a imagem como base64
  static Future<String?> pickImageAsBase64() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.isNotEmpty) {
      final fileBytes = result.files.first.bytes;
      if (fileBytes != null) {
        // Converte os bytes para base64
        return base64Encode(fileBytes);
      }
    }
    return null;
  }

  // Função auxiliar para converter base64 em bytes (caso precise exibir a imagem)
  static Uint8List? base64ToBytes(String base64String) {
    try {
      return base64Decode(base64String);
    } catch (e) {
      return null;
    }
  }
}
