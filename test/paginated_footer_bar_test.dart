import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hcp_profiling/screens/components/paginated_footer_bar.dart';

void main() {
  testWidgets('PaginatedFooterBar displays range preview and handles 20/40/80/100',
      (WidgetTester tester) async {
    int? changedPage;
    int? changedSize;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: PaginatedFooterBar(
            currentPage: 1,
            pageSize: 20,
            totalItems: 85,
            entityLabel: 'HCPs',
            onPageChanged: (p) => changedPage = p,
            onPageSizeChanged: (s) => changedSize = s,
          ),
        ),
      ),
    );

    expect(find.textContaining('1\u201320', findRichText: true), findsOneWidget);
    expect(find.textContaining('85', findRichText: true), findsOneWidget);
    expect(find.text('1 / 5'), findsOneWidget);

    for (final sizeLabel in ['20', '40', '80', '100']) {
      expect(find.text(sizeLabel), findsOneWidget);
    }

    await tester.tap(find.text('Next'));
    await tester.pump();
    expect(changedPage, 2);

    await tester.tap(find.text('40'));
    await tester.pump();
    expect(changedSize, 40);
  });

  testWidgets('PaginatedFooterBar handles empty list and Prev boundary',
      (WidgetTester tester) async {
    int? changedPage;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: PaginatedFooterBar(
            currentPage: 1,
            pageSize: 20,
            totalItems: 0,
            entityLabel: 'institutions',
            onPageChanged: (p) => changedPage = p,
            onPageSizeChanged: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('1'), findsOneWidget);
    expect(find.textContaining('institutions', findRichText: true), findsOneWidget);

    await tester.tap(find.text('Prev'));
    await tester.pump();
    expect(changedPage, isNull);
  });
}
