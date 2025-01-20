import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snaptag_kiosk/lib.dart';

class FrontImagesAction extends ConsumerWidget {
  const FrontImagesAction({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<String> frontPhotoListState = ref.watch(frontPhotoListProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            ElevatedButton(
              onPressed: () async {
                try {
                  await ref.read(frontPhotoListProvider.notifier).fetch();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('이미지 저장 성공!')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('이미지 저장 실패: $e')),
                    );
                  }
                }
              },
              child: const Text('Call API'),
            ), // 이미지 삭제 버튼
            ElevatedButton(
              onPressed: () async {
                try {
                  await ref.read(frontPhotoListProvider.notifier).clearImages();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('이미지 삭제 성공!')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('이미지 삭제 실패: $e')),
                    );
                  }
                }
              },
              child: const Text('Clear Directory'),
            ),
            FilePathActions(
              directory: DirectoryPaths.frontImages,
            ),
          ],
        ),
        const SizedBox(height: 20),

        // 저장된 이미지 표시
        Wrap(
          children: [
            for (final photo in frontPhotoListState)
              Image.file(
                File(photo),
                width: 200,
                height: 300,
                fit: BoxFit.cover,
              ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
