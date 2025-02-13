import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_snaptag_kiosk/features/move_me/widgets/code_keypad.dart';
import 'package:flutter_snaptag_kiosk/lib.dart';
import 'package:flutter_svg/flutter_svg.dart';

class KioskInfoScreen extends ConsumerWidget {
  const KioskInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          padding: EdgeInsets.only(left: 30.w),
          icon: SvgPicture.asset(SnaptagSvg.arrowBack),
          onPressed: () async {
            final result = await DialogHelper.showSetupDialog(
              context,
              title: '메인페이지로 이동합니다.',
            );
            if (result) {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text('이벤트 미리보기'),
        excludeHeaderSemantics: false,
        backgroundColor: Colors.white.withOpacity(0.7),
        shadowColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () async {
              String? value = await showDialog<String>(
                context: context,
                barrierDismissible: true,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    insetPadding: EdgeInsets.symmetric(horizontal: 100.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    content: SizedBox(
                      width: 418.w,
                      height: 600.h,
                      child: AuthCodeKeypad(
                        onCompleted: (code) {
                          // 완료 시 실행할 로직
                          print("입력된 코드: $code");
                          return Navigator.pop(context, code);
                        },
                      ),
                    ),
                  );
                },
              );

              if (value == null || value.isEmpty) return; // 값이 없으면 종료

              final result = await DialogHelper.showSetupDialog(context, title: '최신 이벤트로 새로고침 됩니다.');
              if (result == true) {
                await ref.read(asyncKioskInfoProvider.notifier).refreshWithMachineId(int.parse(value));
              }
            },
            icon: SvgPicture.asset(
              'assets/icons/refresh.svg',
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: ref.watch(asyncKioskInfoProvider).when(
        data: (info) {
          return Column(
            children: [
              Image.network(
                info.topBannerUrl,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: const Text('이미지를 찾을 수 없습니다.'),
                  );
                },
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.network(
                    info.mainImageUrl,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: const Text('이미지를 찾을 수 없습니다.'),
                      );
                    },
                  ),
                  if (F.appFlavor == Flavor.dev) KioskInfoWidget(info: info),
                ],
              ),
            ],
          );
        },
        error: (error, stack) {
          return GeneralErrorWidget(
            exception: error as Exception,
            onRetry: () => ref.refresh(asyncKioskInfoProvider),
          );
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
