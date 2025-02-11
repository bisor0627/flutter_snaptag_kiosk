import 'dart:math';

import 'package:flutter_snaptag_kiosk/core/utils/file_logger.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_snaptag_kiosk/domain/entities/SeletedFrontPhoto.dart';

class RandomPhotoUtil {
  static Seletedfrontphoto? getRandomWeighted(List<String> dataList) {
    try {
      // 가중치 추출
      final parsedData = dataList
          .map((filePath) {
            final fileName = path.basenameWithoutExtension(filePath);
            final parts = fileName.split('_');
            final id = int.tryParse(parts[0]);
            final code = int.tryParse(parts[1]);
            final embeddingProductId = int.tryParse(parts[2]);
            final weight = int.tryParse(parts[3]) ?? 0;
            final isWin = parts[4] == '1';

            if (id == null || code == null || embeddingProductId == null) {
              return null;
            }
            return Seletedfrontphoto(
              id: id,
              code: code,
              embeddingProductId: embeddingProductId,
              weight: weight,
              isWin: isWin,
              path: filePath,
            );
          })
          .where((item) => item != null)
          .toList(); // 유효한 값만 필터링

      // 총 가중치 계산
      final totalWeight = parsedData.fold(0, (sum, item) => sum + item!.weight);

      // 랜덤 값 생성
      final randomValue = Random().nextInt(totalWeight);

      // 누적 가중치 계산 및 랜덤 값 비교
      int cumulativeWeight = 0;
      return parsedData.firstWhere((item) {
        cumulativeWeight += item!.weight;
        return randomValue < cumulativeWeight;
      }, orElse: () => null);
    } catch (e) {
      // FileLogger.warning('이미지 정보 추출 중 오류가 발생했습니다: $e');
      return null;
    }
  }

  // 특정 이미지의 정보를 추출하는 메서드
  static ({int id, int code, int embeddingProductId})? _getPhotoInfo(
      String imagePath) {
    try {
      final fileName = path.basenameWithoutExtension(imagePath);
      final parts = fileName.split('_');

      if (parts.length == 3) {
        final id = int.tryParse(parts[0]);
        final code = int.tryParse(parts[1]);
        final embeddingProductId = int.tryParse(parts[2]);

        if (id != null && code != null && embeddingProductId != null) {
          return (
            id: id,
            code: code,
            embeddingProductId: embeddingProductId,
          );
        }
      }
      throw Exception('Invalid file name format: $fileName');
    } catch (e) {
      FileLogger.warning('이미지 정보 추출 중 오류가 발생했습니다: $e');
      return null;
    }
  }
}
