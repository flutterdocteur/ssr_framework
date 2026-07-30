import 'dart:io';
import 'package:path/path.dart' as path;

class FileUtils {
  /// Create a directory if it doesn't exist
  static Future<void> ensureDirectory(String dirPath) async {
    final dir = Directory(dirPath);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
  }

  /// Write content to a file, creating parent directories if needed
  static Future<void> writeFile(String filePath, String content) async {
    final file = File(filePath);
    await ensureDirectory(path.dirname(filePath));
    await file.writeAsString(content);
  }

  /// Copy a file to a new location
  static Future<void> copyFile(String source, String destination) async {
    final sourceFile = File(source);
    if (!await sourceFile.exists()) {
      throw Exception('Source file does not exist: $source');
    }
    await ensureDirectory(path.dirname(destination));
    await sourceFile.copy(destination);
  }

  /// Delete a directory and all its contents
  static Future<void> deleteDirectory(String dirPath) async {
    final dir = Directory(dirPath);
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }

  /// List all files in a directory matching a pattern
  static Future<List<String>> listFiles(String dirPath, {String? extension}) async {
    final dir = Directory(dirPath);
    if (!await dir.exists()) {
      return [];
    }

    final files = <String>[];
    await for (final entity in dir.list(recursive: true)) {
      if (entity is File) {
        if (extension == null || entity.path.endsWith(extension)) {
          files.add(entity.path);
        }
      }
    }
    return files;
  }

  /// Check if a file exists
  static Future<bool> fileExists(String filePath) async {
    final file = File(filePath);
    return await file.exists();
  }

  /// Read file content as string
  static Future<String> readFile(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception('File does not exist: $filePath');
    }
    return await file.readAsString();
  }
}
