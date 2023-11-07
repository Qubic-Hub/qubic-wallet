import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
// ignore: unused_import
import 'package:intl/intl.dart';
import 'package:qubic_wallet/components/explorer_result_page_qubic_id/explorer_result_page_qubic_id.dart';
import 'package:qubic_wallet/components/explorer_results/explorer_result_page_transaction_item.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/dtos/explorer_id_info_dto.dart';
import 'package:qubic_wallet/dtos/explorer_transaction_info_dto.dart';
import 'package:qubic_wallet/helpers/test_helpers.dart';

void main() {
  setupDI();
  group('ExplorerResultPageQubicId', () {
    final oneTransaction = ExplorerIdInfoDto(
        [
          ExplorerIdInfoReportedValueDto(
              '127.0.0.1', 'public-key-1', 100, 50, 20, 11, 10, 22),
          ExplorerIdInfoReportedValueDto(
              '127.0.0.2', 'public-key-1', 100, 50, 20, 11, 10, 22),
          ExplorerIdInfoReportedValueDto(
              '127.0.0.3', 'public-key-1', 100, 50, 20, 11, 10, 22),
        ],
        'test-id',
        [
          ExplorerTransactionInfoDto(
              "id", true, 1, true, "source", "dest", 100, 0, "digest", true)
        ]);

    final twoTransactions = ExplorerIdInfoDto(
        [
          ExplorerIdInfoReportedValueDto(
              '127.0.0.1', 'public-key-1', 100, 50, 20, 11, 10, 22),
          ExplorerIdInfoReportedValueDto(
              '127.0.0.2', 'public-key-1', 100, 50, 20, 11, 10, 22),
          ExplorerIdInfoReportedValueDto(
              '127.0.0.3', 'public-key-1', 100, 50, 20, 11, 10, 22),
        ],
        'test-id',
        [
          ExplorerTransactionInfoDto(
              "id", true, 1, true, "source", "dest", 100, 0, "digest", true),
          ExplorerTransactionInfoDto(
              "id", true, 1, true, "source", "dest", 100, 0, "digest", true)
        ]);

    testWidgets('should display the correct number of transactions',
        (WidgetTester tester) async {
      FlutterError.onError = ignoreOverflowErrors;
      await tester.pumpWidget(
        MaterialApp(
          home: ExplorerResultPageQubicId(
            idInfo: twoTransactions,
          ),
        ),
      );

      final transactionsHeaderFinder = find.text(
          '${twoTransactions.latestTransfers!.length} transactions in this epoch');
      expect(transactionsHeaderFinder, findsOneWidget);

      final transactionsFinder = find.byType(ExplorerResultPageTransactionItem);
      expect(transactionsFinder,
          findsNWidgets(twoTransactions.latestTransfers!.length));
    });

    testWidgets(
        'should display the correct number of transactions for one transaction',
        (WidgetTester tester) async {
      FlutterError.onError = ignoreOverflowErrors;

      await tester.pumpWidget(
        MaterialApp(
          home: ExplorerResultPageQubicId(
            idInfo: oneTransaction,
          ),
        ),
      );

      final transactionsHeaderFinder = find.text(
          '${oneTransaction.latestTransfers!.length} transaction in this epoch');
      expect(transactionsHeaderFinder, findsOneWidget);

      final transactionsFinder = find.byType(ExplorerResultPageTransactionItem);
      expect(transactionsFinder,
          findsNWidgets(oneTransaction.latestTransfers!.length));
    });

    testWidgets(
        'should display no transactions message when there are no transactions',
        (WidgetTester tester) async {
      FlutterError.onError = ignoreOverflowErrors;

      final noTransactions = ExplorerIdInfoDto(
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

      await tester.pumpWidget(
        MaterialApp(
          home: ExplorerResultPageQubicId(
            idInfo: noTransactions,
          ),
        ),
      );

      final transactionsHeaderFinder =
          find.text('No transactions for this ID in this epoch');
      expect(transactionsHeaderFinder, findsOneWidget);

      final transactionsFinder = find.byType(ExplorerResultPageTransactionItem);
      expect(transactionsFinder, findsNothing);
    });
  });
}
