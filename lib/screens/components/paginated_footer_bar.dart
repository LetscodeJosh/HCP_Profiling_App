import 'package:flutter/material.dart';

/// Compact, responsive static pagination footer matching the web portal
/// preview bar (`Showing X–Y of Z <items>`, `◀ Prev [ 1 / N ] Next ▶`, and
/// `Rows: [ 20 | 40 | 80 | 100 ]`), docked cleanly in `Scaffold.bottomNavigationBar`.
class PaginatedFooterBar extends StatelessWidget {
  final int currentPage;
  final int pageSize;
  final int totalItems;
  final String entityLabel;
  final List<int> pageSizeOptions;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onPageSizeChanged;

  const PaginatedFooterBar({
    Key? key,
    required this.currentPage,
    required this.pageSize,
    required this.totalItems,
    required this.entityLabel,
    this.pageSizeOptions = const [20, 40, 80, 100],
    required this.onPageChanged,
    required this.onPageSizeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int totalPages =
        totalItems <= 0 ? 1 : ((totalItems + pageSize - 1) ~/ pageSize);
    final int safePage = currentPage.clamp(1, totalPages);
    final int startItem = totalItems <= 0 ? 0 : ((safePage - 1) * pageSize) + 1;
    final int endItem =
        totalItems <= 0 ? 0 : (safePage * pageSize).clamp(0, totalItems);
    final bool canGoPrev = safePage > 1;
    final bool canGoNext = safePage < totalPages;

    final Widget summaryText = RichText(
      text: TextSpan(
        style: const TextStyle(
          color: Color(0xFF475569),
          fontSize: 11.5,
        ),
        children: [
          const TextSpan(text: 'Showing '),
          TextSpan(
            text: totalItems <= 0 ? '0' : '$startItem\u2013$endItem',
            style: const TextStyle(
              color: Color(0xFF0066FF),
              fontWeight: FontWeight.w700,
            ),
          ),
          const TextSpan(text: ' of '),
          TextSpan(
            text: '$totalItems',
            style: const TextStyle(
              color: Color(0xFF0B192C),
              fontWeight: FontWeight.w700,
            ),
          ),
          TextSpan(text: ' $entityLabel'),
        ],
      ),
    );

    final Widget navControls = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _NavButton(
          label: 'Prev',
          isPrev: true,
          enabled: canGoPrev,
          onTap: () => onPageChanged(safePage - 1),
        ),
        const SizedBox(width: 6),
        Container(
          constraints: const BoxConstraints(minWidth: 38),
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A0066FF),
                blurRadius: 4,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Text(
            totalPages > 1 ? '$safePage / $totalPages' : '$safePage',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF0B192C),
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 6),
        _NavButton(
          label: 'Next',
          isPrev: false,
          enabled: canGoNext,
          onTap: () => onPageChanged(safePage + 1),
        ),
      ],
    );

    final Widget pageSizeSelector = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Rows:',
          style: TextStyle(
            color: Color(0xFF475569),
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: pageSizeOptions.map((size) {
              final bool isSelected = size == pageSize;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(6),
                    onTap: isSelected ? null : () => onPageSizeChanged(size),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 120),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF0066FF)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '$size',
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF334155),
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFCBD5E1), width: 1.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x0D0B192C),
            blurRadius: 6,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isWide = constraints.maxWidth >= 900;
            if (isWide) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: summaryText),
                    const SizedBox(width: 10),
                    navControls,
                    const SizedBox(width: 12),
                    pageSizeSelector,
                  ],
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  navControls,
                  const SizedBox(height: 5),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      summaryText,
                      Container(
                        width: 1,
                        height: 12,
                        color: const Color(0xFFCBD5E1),
                      ),
                      pageSizeSelector,
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final bool isPrev;
  final bool enabled;
  final VoidCallback onTap;

  const _NavButton({
    required this.label,
    required this.isPrev,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color fgColor =
        enabled ? const Color(0xFF0B192C) : const Color(0xFFCBD5E1);
    final Color borderColor =
        enabled ? const Color(0xFFCBD5E1) : const Color(0xFFE2E8F0);

    return Material(
      color: enabled ? Colors.white : const Color(0xFFF8FAFC),
      borderRadius: BorderRadius.circular(7),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(7),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isPrev) ...[
                Icon(Icons.chevron_left_rounded, size: 15, color: fgColor),
                const SizedBox(width: 2),
                Text(
                  label,
                  style: TextStyle(
                    color: fgColor,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ] else ...[
                Text(
                  label,
                  style: TextStyle(
                    color: fgColor,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(Icons.chevron_right_rounded, size: 15, color: fgColor),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
