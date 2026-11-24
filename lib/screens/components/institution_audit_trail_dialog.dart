import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/lookup_models.dart';

/// Read-only Audit Log dialog displaying facility status, key metadata,
/// and the complete chronological history for an Institution.
class InstitutionAuditTrailDialog extends StatelessWidget {
  final Institution institution;

  const InstitutionAuditTrailDialog({
    Key? key,
    required this.institution,
  }) : super(key: key);

  static Future<void> show(BuildContext context, Institution institution) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => InstitutionAuditTrailDialog(institution: institution),
    );
  }

  List<InstitutionAuditLogEntry> _buildEntries() {
    if (institution.auditTrail.isNotEmpty) {
      return institution.auditTrail;
    }

    final createdAt = (institution.creation != null &&
            institution.creation!.trim().isNotEmpty)
        ? (DateTime.tryParse(institution.creation!) ?? DateTime.now())
        : DateTime.now();

    final locationParts = [
      if ((institution.cityMunicipality ?? '').trim().isNotEmpty)
        institution.cityMunicipality!.trim(),
      if ((institution.provinceName ?? '').trim().isNotEmpty)
        institution.provinceName!.trim(),
      if ((institution.regionName ?? '').trim().isNotEmpty)
        institution.regionName!.trim(),
    ];

    final List<InstitutionAuditLogEntry> synthetic = [
      InstitutionAuditLogEntry(
        timestamp: createdAt,
        user: (institution.owner ?? '').trim().isNotEmpty
            ? institution.owner!.trim()
            : 'Field Representative',
        role: 'Submitter',
        action: 'Initial Proposal',
        details:
            'Submitted "${institution.institutionName}" for facility directory review.',
        snapshot: {
          'facility_name': institution.institutionName,
          if ((institution.institutionType ?? '').trim().isNotEmpty)
            'facility_type': institution.institutionType!.trim(),
          if ((institution.ownership ?? '').trim().isNotEmpty)
            'ownership': institution.ownership!.trim(),
          if ((institution.serviceCapability ?? '').trim().isNotEmpty)
            'service_capability': institution.serviceCapability!.trim(),
          if (locationParts.isNotEmpty) 'location': locationParts.join(', '),
        },
      ),
    ];

    final modifiedAt = (institution.modified != null &&
            institution.modified!.trim().isNotEmpty)
        ? (DateTime.tryParse(institution.modified!) ?? createdAt)
        : createdAt;

    if (institution.isRejected) {
      synthetic.add(
        InstitutionAuditLogEntry(
          timestamp: modifiedAt,
          user: 'SFE Specialist',
          role: 'SFE Reviewer',
          action: 'Rejected by SFE',
          details: (institution.rejectionReason ?? '').trim().isNotEmpty
              ? 'Reason: ${institution.rejectionReason!.trim()}'
              : 'Facility proposal requires correction before approval.',
        ),
      );
    } else if (institution.workflowState == 'Pending DSM Approval') {
      synthetic.add(
        InstitutionAuditLogEntry(
          timestamp: modifiedAt,
          user: 'SFE Specialist',
          role: 'SFE Reviewer',
          action: 'Approved by SFE • Pending DSM',
          details: 'Validated by SFE Specialist and routed for DSM sign-off.',
        ),
      );
    } else if (institution.isApproved) {
      synthetic.add(
        InstitutionAuditLogEntry(
          timestamp: modifiedAt,
          user: 'SFE / DSM Approver',
          role: 'Approver',
          action: 'Approved',
          details: 'Approved and active in the Institution Masterlist.',
        ),
      );
    }

    return synthetic;
  }

  String _formatDateString(String? raw, DateFormat fmt) {
    if (raw == null || raw.trim().isEmpty) return '—';
    final parsed = DateTime.tryParse(raw.trim());
    if (parsed == null) return raw.trim();
    return fmt.format(parsed);
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy • h:mm a');
    final List<InstitutionAuditLogEntry> entries = _buildEntries();

    final Color statusColor;
    final String statusLabel;
    if (institution.workflowState == 'Pending DSM Approval') {
      statusColor = const Color(0xFF7E22CE);
      statusLabel = 'Pending DSM Approval';
    } else if (institution.isApproved) {
      statusColor = const Color(0xFF15803D);
      statusLabel = 'Approved';
    } else if (institution.isRejected) {
      statusColor = const Color(0xFFDC2626);
      statusLabel = 'Rejected';
    } else if (institution.isDraft) {
      statusColor = const Color(0xFF64748B);
      statusLabel = 'Draft';
    } else {
      statusColor = const Color(0xFFD97706);
      statusLabel = 'Pending Approval';
    }

    final locationSummary = [
      if ((institution.streetAddress ?? '').trim().isNotEmpty)
        institution.streetAddress!.trim(),
      if ((institution.cityMunicipality ?? '').trim().isNotEmpty)
        institution.cityMunicipality!.trim(),
      if ((institution.provinceName ?? '').trim().isNotEmpty)
        institution.provinceName!.trim(),
      if ((institution.regionName ?? '').trim().isNotEmpty)
        institution.regionName!.trim(),
    ].join(', ');

    final classificationSummary = [
      if ((institution.ownership ?? '').trim().isNotEmpty)
        institution.ownership!.trim(),
      if ((institution.institutionType ?? '').trim().isNotEmpty)
        institution.institutionType!.trim(),
      if ((institution.serviceCapability ?? '').trim().isNotEmpty)
        institution.serviceCapability!.trim(),
    ].join(' • ');

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 10,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 620, maxHeight: 720),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: const BoxDecoration(
                color: Color(0xFF0B192C),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.history_edu_rounded,
                      color: Color(0xFF38BDF8),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Institution Audit Log',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.5,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          institution.name.isNotEmpty
                              ? '${institution.institutionName} (${institution.name})'
                              : institution.institutionName,
                          style: const TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.white.withOpacity(0.22)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.lock_rounded,
                          color: Color(0xFF38BDF8),
                          size: 12,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'READ-ONLY',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Colors.white70,
                      size: 20,
                    ),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            // Body: Overview + Timeline
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Institution Overview Card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'FACILITY OVERVIEW',
                              style: TextStyle(
                                color: Color(0xFF475569),
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.7,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: statusColor.withOpacity(0.45),
                                ),
                              ),
                              child: Text(
                                statusLabel,
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _SummaryInfoRow(
                          icon: Icons.location_on_outlined,
                          label: 'Location',
                          value: locationSummary.isNotEmpty
                              ? locationSummary
                              : 'Not specified',
                        ),
                        if (classificationSummary.isNotEmpty)
                          _SummaryInfoRow(
                            icon: Icons.local_hospital_outlined,
                            label: 'Classification',
                            value: classificationSummary,
                          ),
                        _SummaryInfoRow(
                          icon: Icons.person_outline_rounded,
                          label: 'Submitted By',
                          value: (institution.owner ?? '').trim().isNotEmpty
                              ? institution.owner!.trim()
                              : 'Field Representative',
                        ),
                        _SummaryInfoRow(
                          icon: Icons.calendar_today_outlined,
                          label: 'Created',
                          value: _formatDateString(
                            institution.creation,
                            dateFormat,
                          ),
                        ),
                        _SummaryInfoRow(
                          icon: Icons.update_rounded,
                          label: 'Last Updated',
                          value: _formatDateString(
                            institution.modified,
                            dateFormat,
                          ),
                        ),
                        if ((institution.linkedDoctorName ?? '')
                            .trim()
                            .isNotEmpty)
                          _SummaryInfoRow(
                            icon: Icons.medical_information_outlined,
                            label: 'Linked Doctor',
                            value: institution.linkedDoctorName!.trim(),
                          ),
                        if (institution.isRejected &&
                            (institution.rejectionReason ?? '')
                                .trim()
                                .isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF2F2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFFCA5A5)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.report_problem_rounded,
                                  size: 15,
                                  color: Color(0xFFDC2626),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Rejection Remarks',
                                        style: TextStyle(
                                          color: Color(0xFF991B1B),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        institution.rejectionReason!.trim(),
                                        style: const TextStyle(
                                          color: Color(0xFFB91C1C),
                                          fontSize: 12,
                                          height: 1.35,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text(
                        'ACTIVITY TIMELINE',
                        style: TextStyle(
                          color: Color(0xFF475569),
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.7,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFBFDBFE)),
                        ),
                        child: Text(
                          '${entries.length} ${entries.length == 1 ? 'event' : 'events'}',
                          style: const TextStyle(
                            color: Color(0xFF1D4ED8),
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Timeline entries (newest on top)
                  for (int index = 0; index < entries.length; index++)
                    _TimelineEventRow(
                      entry: entries[entries.length - 1 - index],
                      isLatest: index == 0,
                      isLast: index == entries.length - 1,
                      dateFormat: dateFormat,
                    ),
                ],
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(16)),
                border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.verified_user_outlined,
                    color: Color(0xFF64748B),
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${entries.length} recorded ${entries.length == 1 ? 'entry' : 'entries'}',
                      style: const TextStyle(
                        color: Color(0xFF475569),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B192C),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Close',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(icon, size: 14, color: const Color(0xFF64748B)),
          ),
          const SizedBox(width: 7),
          SizedBox(
            width: 96,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF0F172A),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineEventRow extends StatelessWidget {
  final InstitutionAuditLogEntry entry;
  final bool isLatest;
  final bool isLast;
  final DateFormat dateFormat;

  const _TimelineEventRow({
    required this.entry,
    required this.isLatest,
    required this.isLast,
    required this.dateFormat,
  });

  @override
  Widget build(BuildContext context) {
    final Color actionColor;
    final IconData actionIcon;
    final actLower = entry.action.toLowerCase();
    if (actLower.contains('initial') || actLower.contains('propose')) {
      actionColor = const Color(0xFF2563EB);
      actionIcon = Icons.add_business_rounded;
    } else if (actLower.contains('resubmit') || actLower.contains('modify')) {
      actionColor = const Color(0xFFD97706);
      actionIcon = Icons.edit_note_rounded;
    } else if (actLower.contains('normalize') || actLower.contains('standardize')) {
      actionColor = const Color(0xFF0D9488);
      actionIcon = Icons.auto_fix_high_rounded;
    } else if (actLower.contains('approve') || actLower.contains('route')) {
      actionColor = const Color(0xFF16A34A);
      actionIcon = Icons.check_circle_rounded;
    } else if (actLower.contains('reject')) {
      actionColor = const Color(0xFFDC2626);
      actionIcon = Icons.cancel_rounded;
    } else {
      actionColor = const Color(0xFF475569);
      actionIcon = Icons.event_note_rounded;
    }

    final snapshotItems = entry.snapshot?.entries
            .where((e) => e.value != null && e.value.toString().trim().isNotEmpty)
            .toList() ??
        const [];

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: actionColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                  border: Border.all(color: actionColor, width: 1.8),
                ),
                child: Icon(actionIcon, size: 14, color: actionColor),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: const Color(0xFFE2E8F0),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: isLast ? 0 : 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isLatest ? const Color(0xFFF8FAFC) : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isLatest
                      ? actionColor.withOpacity(0.35)
                      : const Color(0xFFE2E8F0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: actionColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          entry.action,
                          style: TextStyle(
                            color: actionColor,
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          entry.role,
                          style: const TextStyle(
                            color: Color(0xFF475569),
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.person_outline_rounded,
                        size: 13,
                        color: Color(0xFF64748B),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          entry.user,
                          style: const TextStyle(
                            color: Color(0xFF334155),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        dateFormat.format(entry.timestamp),
                        style: const TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 10.5,
                        ),
                      ),
                    ],
                  ),
                  if (entry.details != null &&
                      entry.details!.trim().isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      entry.details!.trim(),
                      style: const TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: 12.5,
                        height: 1.4,
                      ),
                    ),
                  ],
                  if (snapshotItems.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: snapshotItems.map((e) {
                          final rawKey = e.key.replaceAll('_', ' ');
                          final label = rawKey.isEmpty
                              ? ''
                              : rawKey[0].toUpperCase() + rawKey.substring(1);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 110,
                                  child: Text(
                                    '$label:',
                                    style: const TextStyle(
                                      color: Color(0xFF64748B),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    e.value.toString(),
                                    style: const TextStyle(
                                      color: Color(0xFF1E293B),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
