// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_snaptag_kiosk/lib.dart';

class PhotoCardPreviewScreen extends ConsumerStatefulWidget {
  const PhotoCardPreviewScreen({
    super.key,
  });

  @override
  ConsumerState<PhotoCardPreviewScreen> createState() => _PhotoCardPreviewScreenState();
}

class _PhotoCardPreviewScreenState extends ConsumerState<PhotoCardPreviewScreen> {
  //get http => null;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            LocaleKeys.sub02_txt_01.tr(),
            textAlign: TextAlign.center,
            style: context.typography.kioskBody1B,
          ),
          GradientContainer(
            content: LayoutBuilder(
              builder: (context, constraints) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Image.network(
                    'https://picsum.photos/id/1/200/300', //TODO: 이미지 URL
                    fit: BoxFit.fill,
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PriceBox(),
              ElevatedButton(
                style: context.paymentButtonStyle,
                onPressed: () {
                  PrintProcessRouteData().go(context);
                },
                child: Text(
                  LocaleKeys.sub02_btn_pay.tr(),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
