# HCP Nexus Release Notes — `v.1.0.2-alpha` (`versionName: 1.0.2`, `versionCode: 3`)

- **Release Date:** November 27, 2026
- **Environment:** Staging UAT (`https://staging.pmii-marketing.com`)
- **Application ID:** `com.pims.hcpnexus`
- **Version Name:** `1.0.2` (displayed as `v.1.0.2-alpha` on Login Page)
- **Version Code / Build Number:** `3`

## Key Fixes & Improvements
1. **MedRep Full Institution Count & `INST-00001` (`417 LinkValidationError`) Resolution:**
   - Expanded `ApiService.fetchInstitutions()` across 8 progressive REST/RPC GET tiers plus CSRF-authenticated `frappe.desk.reportview.get` and `frappe.desk.search.search_link` fallbacks, handling 20/50/100/200/250 server page caps cleanly.
   - Added automatic cross-environment disk cache purge (`_purgeAllEnvironmentCaches`) on Staging boot and forced live ERPNext `Institution` ID re-resolution + `417` recovery retry in `createSubmission()`, `updateSubmission()`, and `syncHcpAccount()`.
   - Updated `InstitutionApprovalsScreen` to reflect full live institution totals on MedRep accounts and kept `Change / Remap` accessible even at 2/2 resubmissions.
2. **Human-Readable Error Messages (`ApiService.formatUserFriendlyError`):**
   - Replaced raw JSON/Python tracebacks in submission, approval, institution remap, and doctor dialogs with concise plain-English explanations plus a clean `(Exception Error: <code>)` code.
3. **SFE Dual-Role Admin & Hamburger Menu + `Review` Tab:**
   - Kept full Admin capabilities active for SFE Admins (`_hasSfeRole`) while rendering both their assigned `employeeBranch` and the interactive `Switch Program` dropdown in `AppDrawer`.
   - Relabeled the `Changes` tab and navigation prompts to `Review` in `HcpWizardScreen` and `SubmissionHistoryScreen`, and fixed resubmission workflow actions.
4. **Standalone Territory Reconfiguration Web App (Staging Direct, Zero Streamlit Dependency):**
   - Aligned `server.py` to `https://staging.pmii-marketing.com` with automatic Frappe CSRF handling, preserved user session cookies on `401/403`, enabled `/` territory docnames & multi-column `order_by` in `secure_frappe_gateway.py`, wired direct standalone REST writebacks in all 6 mirrored copies of `territory_reconfiguration_portal.html`, and added one-time Staging `localStorage` hygiene.
