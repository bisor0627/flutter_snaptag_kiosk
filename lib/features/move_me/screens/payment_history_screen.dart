import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_snaptag_kiosk/lib.dart';

class PaymentHistoryScreen extends ConsumerWidget {
  const PaymentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const OrderListPage();
  }
}

class OrderListPage extends ConsumerWidget {
  const OrderListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersPage = ref.watch(ordersPageProvider());
    final themeData = ThemeData(
      colorSchemeSeed: Colors.amberAccent,
      brightness: Brightness.light,
    );

    return Theme(
      data: themeData,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('출력 내역'),
          centerTitle: true,
          scrolledUnderElevation: 0,
        ),
        body: ordersPage.when(
          data: (response) {
            return Column(
              children: [
                SizedBox(
                  width: 438.w,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('yyyy.MM.dd').format(DateTime.now()),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF1C1C1C),
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 4, left: 2, right: 1, bottom: 4),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '-',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF1C1C1C),
                                fontSize: 32.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        DateFormat('yyyy.MM.dd').format(DateTime.now().subtract(const Duration(days: 14))),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF1C1C1C),
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.r)),
                          side: BorderSide(width: 1, color: Color(0xFFE6E8EB))),
                      child: DataTable(
                        decoration: BoxDecoration(
                          color: Color(0xFFF6F7F8),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        headingTextStyle: TextStyle(
                          color: Color(0xFF757575),
                          fontSize: 18.sp,
                        ),
                        dataRowMinHeight: 68.h,
                        dataTextStyle: TextStyle(
                          color: Color(0xFF414448),
                          fontSize: 16.sp,
                        ),
                        columns: columns,
                        rows: response.list.map((order) {
                          return ref.watch(orderDataRowProvider(order));
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                PaginationControls(
                  currentPage: response.paging.currentPage,
                  totalPages: (response.paging.totalCount / response.paging.pageSize).ceil(),
                  onPageChanged: (newPage) {
                    ref.read(ordersPageProvider().notifier).goToPage(newPage);
                  },
                ),
              ],
            );
          },
          loading: () => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  'Loading orders...',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          error: (error, stack) => GeneralErrorWidget(
            exception: error as Exception,
            onRetry: () => ref.refresh(ordersPageProvider()),
          ),
        ),
      ),
    );
  }

  List<DataColumn> get columns {
    return const [
      DataColumn(
        label: Text('일자'),
        headingRowAlignment: MainAxisAlignment.center,
      ),
      DataColumn(
        label: Text('이벤트명'),
        headingRowAlignment: MainAxisAlignment.center,
      ),
      DataColumn(
        label: Text('결제 금액'),
        headingRowAlignment: MainAxisAlignment.center,
      ),
      DataColumn(
        label: Text('결제 상태'),
        headingRowAlignment: MainAxisAlignment.center,
      ),
      DataColumn(
        label: Text('환불 상태'),
        headingRowAlignment: MainAxisAlignment.center,
      ),
      DataColumn(
        label: Text('출력 상태'),
        headingRowAlignment: MainAxisAlignment.center,
      ),
      DataColumn(
        label: Text('인증번호'),
        headingRowAlignment: MainAxisAlignment.center,
      ),
      DataColumn(
        label: Text('결제 승인번호'),
        headingRowAlignment: MainAxisAlignment.center,
      ),
    ];
  }
}

// PaginationControls 위젯은 이전과 동일
class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  const PaginationControls({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> pageButtons() {
      List<Widget> buttons = [];
      int startPage = (currentPage - 5).clamp(1, totalPages > 10 ? totalPages - 9 : 1);
      int endPage = (startPage + 9).clamp(startPage, totalPages);

      for (int i = startPage; i <= endPage; i++) {
        buttons.add(
          InkWell(
            onTap: i != currentPage ? () => onPageChanged(i) : null,
            child: Chip(
              label: Text(
                i.toString(),
                style: TextStyle(
                  color: i == currentPage ? Colors.white : Colors.black,
                  fontSize: 14,
                ),
              ),
              backgroundColor: i == currentPage ? Color(0xFFA671EA) : Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: BorderSide(color: Colors.transparent),
              ),
            ),
          ),
        );
      }
      return buttons;
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // First page button
            InkWell(
              onTap: currentPage > 1 ? () => onPageChanged(1) : null,
              child: const Icon(Icons.keyboard_double_arrow_left_sharp),
            ),
            const SizedBox(width: 8),
            // Previous page button
            InkWell(
              onTap: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
              child: const Icon(Icons.chevron_left),
            ),
            const SizedBox(width: 8),
            // Page buttons
            ...pageButtons(),
            const SizedBox(width: 8),
            // Next page button
            InkWell(
              onTap: currentPage < totalPages ? () => onPageChanged(currentPage + 1) : null,
              child: const Icon(Icons.chevron_right),
            ),
            const SizedBox(width: 8),
            // Last page button
            InkWell(
              onTap: currentPage < totalPages ? () => onPageChanged(totalPages) : null,
              child: const Icon(Icons.keyboard_double_arrow_right_sharp),
            ),
          ],
        ),
      ),
    );
  }
}
