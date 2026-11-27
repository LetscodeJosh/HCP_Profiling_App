import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hcp_profiling/models/lookup_models.dart';
import 'package:hcp_profiling/models/submission.dart';
import 'package:hcp_profiling/screens/components/app_drawer.dart';
import 'package:hcp_profiling/screens/hcp_wizard_screen.dart';
import 'package:hcp_profiling/services/api_service.dart';
import 'package:hcp_profiling/services/data_sanitizer.dart';

void main() {
  group('UserInitialsAvatar & ApiService.computeInitials', () {
    test('computes first + last initials for two and three+ word names', () {
      expect(ApiService.computeInitials('Joshua Tan'), 'JT');
      expect(ApiService.computeInitials('Dexter Huinda'), 'DH');
      expect(ApiService.computeInitials('Dexter Abaigar Huinda'), 'DH');
      expect(ApiService.computeInitials('Allen Paul Miole'), 'AM');
    });

    test('falls back cleanly for single word names and emails', () {
      expect(ApiService.computeInitials('Administrator'), 'AD');
      expect(ApiService.computeInitials('', email: 'joshua.tan@profinsights.biz'), 'JT');
      expect(ApiService.computeInitials(null, email: 'ammiole@profinsights.biz'), 'AM');
      expect(ApiService.computeInitials(null, email: null), 'U');
    });
  });

  group('HcpProfileSubmission New Doctor label retention', () {
    test('pending New HCP returns isNewDoctorSubmission == true', () {
      final sub = HcpProfileSubmission.fromJson({
        'name': 'HCP-PROF-2026-00100',
        'hcp_name': '',
        'profile_action': 'New HCP',
        'workflow_state': 'Pending Approval',
      });
      expect(sub.profileAction, 'New HCP');
      expect(sub.isNewDoctorSubmission, isTrue);
    });

    test('approved & merged New HCP with populated hcp_name retains New Doctor label', () {
      final sub = HcpProfileSubmission.fromJson({
        'name': 'HCP-PROF-2026-00101',
        'hcp_name': 'HCP-0006136',
        'profile_action': 'New HCP',
        'workflow_state': 'Approved',
        'docstatus': 1,
      });
      expect(sub.hcpName, 'HCP-0006136');
      expect(sub.profileAction, 'New HCP');
      expect(sub.isNewDoctorSubmission, isTrue);
    });

    test('merged New HCP with empty profile_action recovers New HCP via changes_json', () {
      final sub = HcpProfileSubmission.fromJson({
        'name': 'HCP-PROF-2026-00102',
        'hcp_name': 'HCP-0006137',
        'profile_action': '',
        'workflow_state': 'Approved',
        'changes_json': '{"hcp":"","is_new_doctor":true,"changes":{}}',
      });
      expect(sub.profileAction, 'New HCP');
      expect(sub.isNewDoctorSubmission, isTrue);
    });

    test('merged New HCP with empty profile_action and empty changes_json recovers via HTML', () {
      final sub = HcpProfileSubmission.fromJson({
        'name': 'HCP-PROF-2026-00103',
        'hcp_name': 'HCP-0006138',
        'profile_action': '',
        'workflow_state': 'Approved',
        'change_summary_html': '<h3>New Doctor Information</h3><br>',
      });
      expect(sub.profileAction, 'New HCP');
      expect(sub.isNewDoctorSubmission, isTrue);
    });

    test('Existing HCP from masterlist returns isNewDoctorSubmission == false', () {
      final sub = HcpProfileSubmission.fromJson({
        'name': 'HCP-PROF-2026-00104',
        'hcp_name': 'HCP-0001001',
        'profile_action': 'Existing HCP',
        'workflow_state': 'Processed',
        'changes_json': '{"hcp":"HCP-0001001","is_new_doctor":false,"changes":{}}',
      });
      expect(sub.profileAction, 'Existing HCP');
      expect(sub.isNewDoctorSubmission, isFalse);
    });
  });

  group('Signature PNG Data URI Rendering', () {
    test('encodes drawn strokes to a valid data:image/png;base64 payload', () async {
      final uri = await renderSignaturePointsToPngDataUri([
        const Offset(20, 40),
        const Offset(120, 90),
        const Offset(280, 50),
        Offset.infinite,
        const Offset(340, 80),
        const Offset(480, 110),
      ]);
      expect(uri.startsWith('data:image/png;base64,'), isTrue);
      final bytes = base64Decode(uri.split(',').last);
      // PNG file signature: 89 50 4E 47 0D 0A 1A 0A
      expect(bytes.length, greaterThan(100));
      expect(bytes.sublist(0, 4), equals([0x89, 0x50, 0x4E, 0x47]));
    });

    test('returns empty string for empty or separator-only points', () async {
      expect(await renderSignaturePointsToPngDataUri([]), '');
      expect(await renderSignaturePointsToPngDataUri([Offset.infinite]), '');
    });

    test('HcpProfileSubmission.toJson preserves case-sensitive PNG signature, photos, JSON, and HTML', () async {
      final uri = await renderSignaturePointsToPngDataUri([
        const Offset(10, 20),
        const Offset(150, 80),
      ]);
      final sub = HcpProfileSubmission(
        hcpName: '',
        firstName: 'Joshua',
        lastName: 'Tan',
        consentSignature: uri,
        consentPhoto: '/files/Consent_Test.jpg',
        changesJson: '{"is_new_doctor":true}',
        changeSummaryHtml: '<h3>New Doctor Information</h3>',
      );
      final json = sub.toJson();
      expect(json['consent_signature'], uri);
      expect(json['consent_signature'].toString().startsWith('data:image/png;base64,'), isTrue);
      final decoded = base64Decode(json['consent_signature'].toString().split(',').last);
      expect(decoded.sublist(0, 4), equals([0x89, 0x50, 0x4E, 0x47]));
      expect(json['consent_photo'], '/files/Consent_Test.jpg');
      expect(json['changes_json'], '{"is_new_doctor":true}');
      expect(json['change_summary_html'], '<h3>New Doctor Information</h3>');
    });
  });

  group('HCP Account Sync Safety (Email & Link ID Preservation)', () {
    test('ApiService.isValidEmailAddress rejects non-email contact type labels', () {
      expect(ApiService.isValidEmailAddress('Email'), isFalse);
      expect(ApiService.isValidEmailAddress('Mobile'), isFalse);
      expect(ApiService.isValidEmailAddress('Phone'), isFalse);
      expect(ApiService.isValidEmailAddress(''), isFalse);
      expect(ApiService.isValidEmailAddress(null), isFalse);
      expect(ApiService.isValidEmailAddress('doctor@hospital.com'), isTrue);
    });

    test('DataSanitizer.sanitizePayload preserves ERPNext Link IDs and program keys', () {
      final sanitized = DataSanitizer.sanitizePayload({
        'hcp_type': 'HCP-TYPE-04',
        'hcp_name': 'HCP-0006136',
        'hcp_workplace': 'INST-00412',
        'workplace': 'INST-00412',
        'institution': 'INST-00412',
        'hcp_specialty': 'SPEC-00008',
        'sub_specialty': 'SUBSPEC-00019',
        'account_or_program': 'COREnergy',
        'profile_action': 'Existing HCP',
        'workflow_state': 'Processed',
        'survey_template': 'SURVEY-CORE-2026',
      });
      expect(sanitized['hcp_type'], 'HCP-TYPE-04');
      expect(sanitized['hcp_name'], 'HCP-0006136');
      expect(sanitized['hcp_workplace'], 'INST-00412');
      expect(sanitized['workplace'], 'INST-00412');
      expect(sanitized['institution'], 'INST-00412');
      expect(sanitized['hcp_specialty'], 'SPEC-00008');
      expect(sanitized['sub_specialty'], 'SUBSPEC-00019');
      expect(sanitized['account_or_program'], 'COREnergy');
      expect(sanitized['profile_action'], 'Existing HCP');
      expect(sanitized['workflow_state'], 'Processed');
      expect(sanitized['survey_template'], 'SURVEY-CORE-2026');
    });
  });

  group('Task T1: MedRep Institution Count & Live Link ID Resolution', () {
    test('mySubmittedInstitutions ignores ownerless baseline institutions and matches real owner', () {
      SharedPreferences.setMockInitialValues({});
      final apiService = ApiService.forTest();
      addTearDown(apiService.dispose);
      apiService.loggedInEmail = 'medrep@pmii-marketing.com';
      apiService.setCachedInstitutionsForTesting([
        Institution(name: 'INST-00001', institutionName: 'Manila Doctors Hospital', workflowState: 'Approved', owner: null),
        Institution(name: 'INST-00002', institutionName: 'Makati Medical Center', workflowState: 'Approved', owner: ''),
        Institution(name: 'INST-00950', institutionName: 'MedRep Clinic', workflowState: 'Pending Approval', owner: 'medrep@pmii-marketing.com'),
      ]);

      final mine = apiService.mySubmittedInstitutions;
      expect(mine.length, 1);
      expect(mine.first.name, 'INST-00950');
    });

    test('LocationResolver maps stale offline INST-00001 to live Staging Institution ID when live list differs', () {
      LocationResolver.clearDynamicInstitutions();
      final liveStagingInsts = [
        Institution(
          name: 'INST-00999',
          institutionName: 'Manila Doctors Hospital',
          cityMunicipality: 'City of Manila',
          provinceName: 'Metro Manila',
          regionName: 'National Capital Region (NCR)',
          workflowState: 'Approved',
        ),
      ];
      expect(LocationResolver.resolveInstitutionId('INST-00001', liveStagingInsts), 'INST-00999');
      final resolved = LocationResolver.resolveCompleteWorkplaceLocation(
        workplaceNameOrId: 'INST-00001',
        institutionName: 'Manila Doctors Hospital',
        institutions: liveStagingInsts,
      );
      expect(resolved.workplaceId, 'INST-00999');
      expect(resolved.workplaceName, 'Manila Doctors Hospital');
    });
  });

  group('Task T2: SFE Dual-Role Admin & Hamburger Menu Branch/Program Selector', () {
    test('SFE user with Admin role keeps BOTH isAdmin and isSfe active; pure Admin keeps isSfe false', () {
      SharedPreferences.setMockInitialValues({});
      final apiService = ApiService.forTest();
      addTearDown(apiService.dispose);

      // Pure IT / System Admin (no SFE role/designation/department/branch)
      apiService.applyPositionForTesting(
        roleProfile: 'Administrator',
        roleNames: ['System Manager', 'Administrator'],
        email: 'it.admin@profinsights.biz',
        designation: 'IT Administrator',
        branch: 'PIMS-ADMIN',
        department: 'Corporate Innovation Group',
      );
      expect(apiService.isAdmin, isTrue);
      expect(apiService.isSfe, isFalse);

      // SFE Specialist who ALSO holds System Manager / Administrator role
      apiService.applyPositionForTesting(
        roleProfile: 'Administrator',
        roleNames: ['System Manager', 'Sales Force Effectiveness'],
        email: 'ammiole@profinsights.biz',
        designation: 'SFE Specialist',
        branch: 'SFE - PIMS',
        department: 'Sales Force Effectiveness',
      );
      expect(apiService.isAdmin, isTrue);
      expect(apiService.isSfe, isTrue);
      expect(apiService.hasSfeRole, isTrue);
      expect(apiService.userDesignationTitle, 'SFE');

      // SFE Manager designation preserves 'SFE Mgr' label
      apiService.applyPositionForTesting(
        roleProfile: 'Administrator',
        roleNames: ['System Manager', 'Sales Force Effectiveness'],
        email: 'sfe.mgr@profinsights.biz',
        designation: 'Sales Force Effectiveness Manager',
        branch: 'SFE - PIMS',
        department: 'Sales Force Effectiveness',
      );
      expect(apiService.isAdmin, isTrue);
      expect(apiService.isSfe, isTrue);
      expect(apiService.userDesignationTitle, 'SFE Mgr');

      // Logout clears dual SFE flag and live institution server flag
      apiService.logout();
      expect(apiService.isSfe, isFalse);
      expect(apiService.hasSfeRole, isFalse);
      expect(apiService.institutionsLoadedFromServer, isFalse);
    });

    testWidgets('AppDrawer shows BOTH assigned branch and Program Selector dropdown for SFE+Admin, static branch only for pure Admin', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final apiService = ApiService.forTest();
      addTearDown(apiService.dispose);
      apiService.selectedProgram = 'Abbott Diabetes Care';
      apiService.applyPositionForTesting(
        roleProfile: 'Administrator',
        roleNames: ['System Manager', 'Sales Force Effectiveness'],
        email: 'sfe.admin@profinsights.biz',
        designation: 'SFE Specialist',
        branch: 'SFE - PIMS',
        department: 'Sales Force Effectiveness',
      );

      await tester.pumpWidget(
        ChangeNotifierProvider<ApiService>.value(
          value: apiService,
          child: const MaterialApp(
            home: Scaffold(
              body: AppDrawer(currentItem: DrawerItem.dashboard),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('SFE - PIMS'), findsOneWidget);
      expect(find.text('Abbott Diabetes Care'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);

      // Now switch to pure non-SFE Admin: shows static branch only, no dropdown
      apiService.applyPositionForTesting(
        roleProfile: 'Administrator',
        roleNames: ['System Manager'],
        email: 'it.only@profinsights.biz',
        designation: 'IT Administrator',
        branch: 'CIG-IT',
        department: 'Corporate Innovation Group',
      );
      await tester.pump();

      expect(find.text('CIG-IT'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_drop_down), findsNothing);
    });
  });

  group('Human-Readable Error Formatter (ApiService.formatUserFriendlyError)', () {
    test('turns raw Frappe 417 LinkValidationError JSON traceback into clean plain-English message with code', () {
      const rawError = 'Exception: Failed to create submission: 417 - '
          '{"exception":"frappe.exceptions.LinkValidationError: Could not find Row #1: Workplace: INST-00001",'
          '"exc_type":"LinkValidationError","exc":"[\\"Traceback (most recent call last):\\n...\\"]"}';
      final msg = ApiService.formatUserFriendlyError(rawError, actionLabel: 'submit doctor profile');
      expect(msg, contains('workplace'));
      expect(msg, contains('(Exception Error: 417)'));
      expect(msg, isNot(contains('Traceback')));
      expect(msg, isNot(contains('LinkValidationError')));
      expect(msg, isNot(contains('{')));
    });

    test('formats 403 permission, 500 server, and offline network errors cleanly', () {
      final err403 = ApiService.formatUserFriendlyError('Exception: HTTP 403 Forbidden - PermissionError');
      expect(err403, contains('(Exception Error: 403)'));
      expect(err403, isNot(contains('Exception: HTTP')));

      final err500 = ApiService.formatUserFriendlyError('Exception: Server returned 500 Internal Server Error');
      expect(err500, contains('(Exception Error: 500)'));

      final errNet = ApiService.formatUserFriendlyError('SocketException: Failed host lookup: staging.pmii-marketing.com');
      expect(errNet.toLowerCase(), contains('internet connection'));
      expect(errNet, isNot(contains('SocketException')));
    });

    test('preserves clean domain validation notices without Exception prefix', () {
      final msg = ApiService.formatUserFriendlyError(
        'Exception: Cannot submit doctor profile: Workplace "Test Clinic" was rejected by SFE Specialist.',
      );
      expect(msg, startsWith('Cannot submit doctor profile:'));
      expect(msg, isNot(startsWith('Exception:')));
    });
  });
}
