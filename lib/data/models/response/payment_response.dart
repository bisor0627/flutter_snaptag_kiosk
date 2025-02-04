import 'package:flutter_snaptag_kiosk/lib.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_response.freezed.dart';
part 'payment_response.g.dart';

@freezed
class PaymentResponse with _$PaymentResponse {
  const PaymentResponse._(); // freezed에서 메서드를 추가하기 위한 private constructor

  const factory PaymentResponse({
    @JsonKey(name: 'APPROVALNO') String? approvalNo,
    @JsonKey(name: 'CARDNAME') String? cardName,
    @JsonKey(name: 'CARDTYPE') String? cardType,
    @JsonKey(name: 'CLASSFLAG') String? classFlag,
    @JsonKey(name: 'COMPANYINFO') String? companyInfo,
    @JsonKey(name: 'CORPRESPCODE') String? corpRespCode,
    @JsonKey(name: 'RES') required String res,
    @JsonKey(name: 'RESPCODE') String? respCode,
    @JsonKey(name: 'MSG') String? msg,
    @JsonKey(name: 'TELEGRAMFLAG') String? telegramFlag,
    @JsonKey(name: 'TRADEUNIQUENO') String? tradeUniqueNo,
    @JsonKey(name: 'TRADETIME') String? tradeTime,
    @JsonKey(name: 'STATUS') String? status,
    @JsonKey(name: 'KSNET') String? ksnet,
  }) = _PaymentResponse;

  factory PaymentResponse.fromJson(Map<String, dynamic> json) => _$PaymentResponseFromJson(_trimValues(json));

  bool get isSuccess => res == '0000';

  String get errorMessage => msg?.trim() ?? '결제 처리 중 오류가 발생했습니다.';
}

// 모든 String 값의 공백을 trim
Map<String, dynamic> _trimValues(Map<String, dynamic> json) {
  return json.map((key, value) {
    if (value is String) {
      return MapEntry(key, value.trim());
    }
    return MapEntry(key, value);
  });
}

extension PaymentResponseExtension on PaymentResponse {
  ///
  /// 0: 실패
  ///
  /// 1: 성공
  ///
  /// 2: 기타 오류
  ///
  int get status {
    // RES 코드 체크 (주요 오류 상태)
    switch (res) {
      case '1000':
      case '1003':
      case '1004':
        return 0;
      case '0000':
        // RES가 정상이면 RESPCODE 확인
        switch (respCode) {
          case '0000':
            return 1;
          case '7001':
          case '7002':
          case '7003':
          case '8324':
          case '8325':
          case '8326':
          case '8327':
          case '8328':
          case '8329':
          case '8330':
          case '8331':
          case '8332':
          case '8350':
          default:
            return 2;
        }
      default:
        return 2;
    }
  }

  ///
  /// `0210`: 결제 요청 Response
  ///
  ///   -> return 1
  ///
  /// `0430`: 취소 요청 Response
  ///
  ///   -> return 2
  ///
  /// `0450`: 망취소 Response (승인 번호 없음)
  ///
  /// `0470`: 망취소 Response (승인 번호 있음)
  ///
  ///   -> return 0
  ///
  int get requestType {
    switch (telegramFlag) {
      case '0210':
        return 1;
      case '0430':
        return 2;
      case '0450':
      case '0470':
      default:
        return 0;
    }
  }

  OrderStatus get orderState {
    if (requestType == 1) {
      switch (status) {
        case 1:
          return OrderStatus.completed;
        case 2:
        case 0:
        default:
          return OrderStatus.failed;
      }
    } else if (requestType == 2) {
      switch (status) {
        case 1:
          return OrderStatus.refunded;
        case 2:
        case 0:
        default:
          return OrderStatus.refunded_failed;
      }
    } else {
      return OrderStatus.failed;
    }
  }
}
