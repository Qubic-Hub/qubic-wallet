import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:qubic_wallet/components/explorer_result_page_tick/explorer_result_page_tick_header.dart';
import 'package:qubic_wallet/dtos/explorer_tick_info_dto.dart';

void main() {
  final DateTime now = DateTime.now();

  group('ExplorerResultPageTickHeader', () {
    testWidgets('should display tick info', (WidgetTester tester) async {
      final tickInfo = ExplorerTickInfoDto(
          true, "TL-ID", 1, "AA", "SIGN", true, true, 123456, now, null);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExplorerResultPageTickHeader(
              tickInfo: tickInfo,
            ),
          ),
        ),
      );

      expect(find.text('Tick 123.456'), findsOneWidget);
      expect(find.text('Block Status'), findsOneWidget);
      expect(find.text('Data Status'), findsOneWidget);
      expect(find.text('Non Empty'), findsOneWidget);
      expect(find.text('Completed'), findsOneWidget);
      expect(find.text("Tick Leader - (Short Code / Index)"), findsOneWidget);
      expect(find.text("TL-ID"), findsOneWidget);
      expect(
          find.text(
              "${tickInfo.tickLeaderId}- (${tickInfo.tickLeaderShortCode} / ${tickInfo.tickLeaderIndex})"),
          findsOneWidget);
    });

    testWidgets('should display empty tick info', (WidgetTester tester) async {
      final tickInfo = ExplorerTickInfoDto(
          false, "TL-ID", 1, "AA", "SIGN", false, false, 123456, now, null);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExplorerResultPageTickHeader(
              tickInfo: tickInfo,
            ),
          ),
        ),
      );

      expect(find.text('Tick 123.456'), findsOneWidget);
      expect(find.text('Block Status'), findsOneWidget);
      expect(find.text('Data Status'), findsOneWidget);
      expect(find.text('Empty'), findsOneWidget);
      expect(find.text('Not validated'), findsOneWidget);
    });
  });
}
