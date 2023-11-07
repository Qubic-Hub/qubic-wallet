import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
// ignore: unused_import
import 'package:intl/intl.dart';
import 'package:qubic_wallet/components/explorer_result_page_qubic_id/explorer_result_page_qubic_id_header.dart';
import 'package:qubic_wallet/dtos/explorer_id_info_dto.dart';
import 'package:qubic_wallet/helpers/test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('ExplorerResultPageQubicIdHeader', () {
    final idInfo = ExplorerIdInfoDto(
      [
        ExplorerIdInfoReportedValueDto(
            '127.0.0.1', 'public-key-1', 100, 50, 20, 11, 10, 22),
        ExplorerIdInfoReportedValueDto(
            '127.0.0.2', 'public-key-1', 100, 50, 20, 11, 10, 22),
        ExplorerIdInfoReportedValueDto(
            '127.0.0.3', 'public-key-1', 100, 50, 20, 11, 10, 22),
      ],
      'test-id',
      null,
    );

    final nonEqualIdInfo = ExplorerIdInfoDto(
      [
        ExplorerIdInfoReportedValueDto(
            '127.0.0.1', 'public-key-1', 101, 51, 23, 12, 13, 23),
        ExplorerIdInfoReportedValueDto(
            '127.0.0.2', 'public-key-1', 102, 52, 22, 13, 12, 24),
        ExplorerIdInfoReportedValueDto(
            '127.0.0.3', 'public-key-1', 103, 53, 21, 14, 11, 25),
      ],
      'test-id',
      null,
    );

    testWidgets('displays Qubic ID', (WidgetTester tester) async {
      FlutterError.onError = ignoreOverflowErrors;
      await tester.pumpWidget(
        MaterialApp(
          home: ExplorerResultPageQubicIdHeader(idInfo: idInfo),
        ),
      );

      expect(find.text('Qubic ID\ntest-id'), findsOneWidget);
    });

    testWidgets('displays peer reports in unified string for equal items',
        (WidgetTester tester) async {
      FlutterError.onError = ignoreOverflowErrors;
      await tester.pumpWidget(
        MaterialApp(
          home: ExplorerResultPageQubicIdHeader(idInfo: idInfo),
        ),
      );

      expect(find.text('127.0.0.1, 127.0.0.2, 127.0.0.3'), findsOneWidget);
    });

    testWidgets('displays peer reports in unified string for equal items',
        (WidgetTester tester) async {
      FlutterError.onError = ignoreOverflowErrors;
      await tester.pumpWidget(
        MaterialApp(
          home: ExplorerResultPageQubicIdHeader(idInfo: nonEqualIdInfo),
        ),
      );

      expect(find.text('Value reported by 127.0.0.1'), findsOneWidget);
      expect(find.text('Value reported by 127.0.0.2'), findsOneWidget);
      expect(find.text('Value reported by 127.0.0.3'), findsOneWidget);
    });
  });
}
