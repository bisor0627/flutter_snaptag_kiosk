import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snaptag_kiosk/lib.dart';

class KioskInfoScreen extends ConsumerWidget {
  const KioskInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 비동기 상태 감시
    final info = ref.watch(storageServiceProvider).settings;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kiosk Info'),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(asyncKioskInfoProvider.notifier).refresh();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.network(info.topBannerUrl),
            Stack(
              alignment: Alignment.center,
              children: [
                Image.network(info.mainImageUrl),
                KioskInfoTextWidget(info: info),
              ],
            ),
            FrontImagesAction(),
          ],
        ),
      ),
    );
  }
}
