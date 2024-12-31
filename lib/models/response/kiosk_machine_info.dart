import 'package:freezed_annotation/freezed_annotation.dart';

part 'kiosk_machine_info.freezed.dart';
part 'kiosk_machine_info.g.dart';

@freezed
class KioskMachineInfo with _$KioskMachineInfo {
  const factory KioskMachineInfo({
    @Default(0) int kioskEventId,
    @Default(0) int kioskMachineId,
    @Default('') String kioskMachineName,
    @Default('') String kioskMachineDescription,
    @Default(0) int photoCardPrice,
    @Default('') String printedEventName,
    @Default('') String topBannerUrl,
    @Default('') String mainImageUrl,
    @Default('#FF0000') String mainButtonColor,
    @Default('#FFFFFF') String buttonTextColor,
    @Default('#000000') String couponTextColor,
    @Default('#000000') String mainTextColor,
    @Default('#0000FF') String popupButtonColor,
    @Default('#CCCCCC') String keyPadColor,
  }) = _KioskMachineInfo;

  factory KioskMachineInfo.fromJson(Map<String, dynamic> json) => _$KioskMachineInfoFromJson(json);
}
