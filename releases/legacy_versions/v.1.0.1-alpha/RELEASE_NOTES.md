# HCP Nexus App — Release Notes (`v.1.0.1-alpha`)

**Release Date:** November 25, 2026
**Version:** `v.1.0.1-alpha` (Build 2 / `1.0.1+2` for TestFlight numeric `CFBundleShortVersionString` compliance)
**Bundle ID / Package Name (`applicationId` / `namespace`):** `com.pims.hcpnexus`
**Backend Environment:** `Environment.staging` (`https://staging.pmii-marketing.com`)

## Highlights
- **Step 2 & ERPNext Query Fixes**: Sends `'show_hcp_form': 1` on every HCP submission so Step 2 (`DOCTOR'S INFORMATION`) always expands in ERPNext Desk, and removes `"rejection_reason"` from REST list `fields` to eliminate `Field not permitted in query: rejection_reason`.
- **Step 3 Questionnaire Auto-Populate & Smart Redirect**: Multi-tier `HCP Survey Template` fetch + cache-aside (`fields=["*"]`), `Select`/`Multi-select`/`Data` question inputs, and automatic redirect from Step 2 → `Changes` when no questionnaire is configured for the active program.
- **No Stock Doctor Image Fallback**: Doctor's Information Sheet renders a portrait preview only when a real `hcpPhoto` exists.
- **HCP Profile Submission & Institution Submission UI**: Centered the 5 popup workflow tabs (`Step 1`..`Changes`); upgraded **Institution Submission** to 5 Web-App-style colored card-tabs (`All`, `Pending Approval`, `Pending DSM Approval`, `Approved`, `Rejected`) with the search bar positioned cleanly below and compact inline `Audit Log` / `Edit` buttons without blank card footers.
