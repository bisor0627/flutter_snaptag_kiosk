import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snaptag_kiosk/features/admin/providers/front_photo_list.dart';

import '../models/printer_settings.dart';
import '../printer/card_printer.dart';

class PrintTestScreen extends ConsumerWidget {
  const PrintTestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final frontPhotoListState = ref.watch(frontPhotoListProvider);
    final printerState = ref.watch(printerStateProvider);
    final settings = ref.watch(printerSettingsStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Card Printer')),
      body: printerState.when(
        data: (status) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Printer Status: $status'),
            const SizedBox(height: 20),
            Wrap(
              children: [
                for (final photo in frontPhotoListState)
                  Image.file(
                    File(photo.localPath),
                    width: 200,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
              ],
            ),
            SwitchListTile(
              title: const Text('Double Sided Print'),
              value: settings.doubleSided,
              onChanged: (value) {
                ref.read(printerSettingsStateProvider.notifier).setDoubleSided(value);
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 로컬 파일 경로 예시 (실제 경로로 수정 필요)
                ref.read(printerStateProvider.notifier).printImage(
                      frontImagePath: frontPhotoListState.isNotEmpty ? frontPhotoListState[0].localPath : '',
                      backImagePath: frontPhotoListState.isNotEmpty ? frontPhotoListState[1].localPath : '',
                    );
              },
              child: const Text('Print Card'),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
