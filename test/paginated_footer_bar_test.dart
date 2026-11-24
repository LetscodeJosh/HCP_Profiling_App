import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hcp_profiling/screens/components/paginated_footer_bar.dart';

void main() {
  testWidgets(
      'PaginatedFooterBar renders compact static bar on iPad width without squeezing body',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1100, 700);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    int? changedPage;
    int? changedSize;
    const bodyKey = Key('scaffold_body_content');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: const SizedBox.expand(key: bodyKey),
          bottomNavigationBar: PaginatedFooterBar(
            currentPage: 1,
            pageSize: 20,
            totalItems: 1328,
            entityLabel: 'institutions',
            onPageChanged: (p) => changedPage = p,
            onPageSizeChanged: (s) => changedSize = s,
          ),
        ),
      ),
    );

    final footerSize = tester.getSize(find.byType(PaginatedFooterBar));
    final bodySize = tester.getSize(find.byKey(bodyKey));
    expect(footerSize.height, lessThan(60));
    expect(bodySize.height, greaterThan(600));

    expect(find.textContaining('1\u201320', findRichText: true), findsOneWidget);
    expect(find.textContaining('1328', findRichText: true), findsOneWidget);
    expect(find.text('1 / 67'), findsOneWidget);
    expect(find.text('Hide'), findsNothing);

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

  testWidgets(
      'PaginatedFooterBar renders compact mobile layout without overflow and respects Prev boundary',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    const mobileBodyKey = Key('mobile_scaffold_body');
    int? changedPage;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: const SizedBox.expand(key: mobileBodyKey),
          bottomNavigationBar: PaginatedFooterBar(
            currentPage: 1,
            pageSize: 20,
            totalItems: 0,
            entityLabel: 'HCPs',
            onPageChanged: (p) => changedPage = p,
            onPageSizeChanged: (_) {},
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byType(PaginatedFooterBar)).height, lessThan(110));
    expect(tester.getSize(find.byKey(mobileBodyKey)).height, greaterThan(700));
    expect(find.text('1'), findsOneWidget);
    expect(find.textContaining('HCPs', findRichText: true), findsOneWidget);

    await tester.tap(find.text('Prev'));
    await tester.pump();
    expect(changedPage, isNull);
  });
}
