# VenuRite Data Processing Agreement (Schedule 2 to the Client Agreement)

**Draft version 2026-10-17**

> **⚠️ Draft for solicitor review. This is not legal advice.**
> - This agreement is written to meet Article 28 of the UK GDPR.
> - Check the sub-processor list, international transfers and security measures against the live system before use.
> - **[Solicitor]** notes mark points needing specific attention.

---

## 1. Roles

1.1 For personal data the Client puts into VenuRite, or creates in it (the "**Client Personal Data**"):
- **the Client is the controller;**
- **VenuRite is the processor.**

1.2 This agreement forms part of the Client Agreement. If the two conflict on data protection, this agreement wins.

## 2. Details of the processing

| | |
|---|---|
| **Subject matter** | Providing the VenuRite compliance software to the Client |
| **Duration** | The term of the Client Agreement, plus the export and deletion periods in clause 9 |
| **Nature and purpose** | Hosting, storing, displaying, reporting on and exporting the Client's compliance records. Running staff log-in, clock-in, rota and training. Sending notifications. Generating reports and the audit export. Optional AI features. |
| **Data subjects** | The Client's staff and managers. People named in records, such as delivery drivers or contractors named in notes. Guests, only where the Client records them, such as an allergy request or an incident report. |
| **Categories of personal data** | See below |
| **Special category data** | None is required. Staff may record that a worker was excluded for illness (for example, sickness and diarrhoea), which is health data. The Client must have a lawful basis and an Article 9 condition for this. **[Solicitor]** |

**Categories of personal data:**
- Names, job titles and roles.
- Staff PINs, stored only as one-way hashes.
- Contact details, for managers.
- Preferred language.
- Device push tokens.
- Shift times, rota, days off and shift-booking history.
- Clock-in/out times, with optional photos.
- Clock-in location: **only** whether the person was on-site or off-site and their distance from the venue. Raw coordinates are not stored.
- Task records, with optional photos, notes and readings.
- How long each check was open.
- Integrity flags, visible to managers only.
- Training reads, quiz results and certificates.
- Incident and complaint reports.
- Which device was used (branch device name, or "personal phone").

## 3. VenuRite's obligations

VenuRite will:

3.1 process Client Personal Data only on the Client's documented instructions. Those instructions are this agreement, the Client Agreement, and the Client's use of the Service's settings. VenuRite will tell the Client if it believes an instruction breaks data protection law.

3.2 make sure everyone processing the data is bound by confidentiality.

3.3 apply the security measures in the Annex.

3.4 use sub-processors only as set out in clause 4.

3.5 help the Client, taking into account the nature of the processing, to respond to data subjects' requests (access, correction, deletion and so on). The Service's own tools cover most of these: staff editing, deactivation and the data export.

3.6 help the Client with security, breach notification, data protection impact assessments and prior consultation, as far as is reasonable.

3.7 notify the Client **without undue delay, and within 48 hours**, after becoming aware of a personal data breach affecting Client Personal Data. The notice will include what VenuRite knows, and VenuRite will update it as it learns more.

3.8 delete or return the data when the agreement ends, as in clause 9.

3.9 make available the information needed to show compliance with this agreement, and allow reasonable audits, as in clause 8.

## 4. Sub-processors

4.1 The Client gives general authorisation for VenuRite to use sub-processors. The current list is:

| Sub-processor | What for | Where |
|---|---|---|
| IONOS SE / IONOS Cloud Ltd | Server hosting: database, files, application | UK/EU data centre **[confirm location]** |
| Google (Firebase Cloud Messaging) | Push notifications (device token, message text) | Global; may include the US |
| OpenAI | AI assistant answers and AI-drafted quiz questions. Receives the question or guide text only. Staff names are not sent intentionally. | US |
| GoCardless | Direct Debit payments: Client's billing contact and bank mandate. VenuRite is a separate controller for this. | UK/EU |
| Backblaze (planned) | Encrypted off-site backups | EU or US region **[confirm on setup]** |

4.2 VenuRite will give at least 30 days' notice before adding or replacing a sub-processor. The Client may object on reasonable data-protection grounds. If the parties can't resolve the objection, the Client may cancel the affected service.

4.3 VenuRite will put contract terms in place with each sub-processor that are at least as protective as this agreement. VenuRite remains responsible for its sub-processors.

## 5. International transfers

5.1 Where Client Personal Data is transferred outside the UK, VenuRite will make sure a valid transfer mechanism is in place. Options include:
- UK adequacy regulations;
- the UK International Data Transfer Agreement;
- the UK Addendum to the EU Standard Contractual Clauses;
- the UK Extension to the EU-US Data Privacy Framework, where the recipient is certified.

**[Solicitor]** Confirm the mechanism for OpenAI and Google, and whether a transfer risk assessment is needed.

## 6. The Client's obligations

The Client will:

6.1 have a lawful basis for all processing it instructs.

6.2 give its staff the privacy information they need, including about the monitoring features it turns on: photo checks, location checks at clock-in, integrity flags, and device rules. The Service provides notices staff see before photo and location checks are first used.

6.3 decide fairly what to do about integrity flags, which are indicators and not proof. It will not make decisions about staff solely on an automated flag.

6.4 not put unnecessary personal data into free-text notes or photos.

## 7. Monitoring features: data minimisation by design

For the Client's DPIA, the Service is designed as follows:

7.1 **Location** is read only at clock-in/out, and for critical checks where the venue turns it on. It is never tracked continuously. Only on-site/off-site and the distance are stored.

7.2 **Photo checks** at clock-in can be declined by the worker. A supervisor verification route is available instead. Clock-in photos are deleted automatically after the retention period the venue sets.

7.3 **Integrity flags** are visible only to venue managers and above. Staff are not told about individual flags, so managers can look into them fairly. No public score is shown.

## 8. Audits

8.1 On reasonable notice, and no more than once a year (unless there has been a breach or a regulator requires it), VenuRite will answer the Client's reasonable written questions about its compliance.

8.2 VenuRite will allow an audit by the Client or its independent auditor, at the Client's cost, under confidentiality. VenuRite may provide an independent security report instead, where that answers the question.

## 9. End of processing

9.1 For 30 days after the Client Agreement ends, the Client can export its data using the Service.

9.2 After that, VenuRite deletes Client Personal Data within a further 60 days. Backups are overwritten in their normal cycle, within 30 days. VenuRite may keep data only where the law requires.

## 10. Liability

10.1 Each party's liability under this agreement is subject to the limits in the Client Agreement. **[Solicitor]** Consider whether a separate cap for data-protection claims is needed.

---

## Annex: Security measures (summary)

- **Encryption in transit:** HTTPS/TLS for all app and API traffic.
- **Tenant isolation:** row-level security in the database checks every read and write against the user's own business, branch and role, using signed session tokens. The server, not the app, decides what each user can do.
- **Staff PINs:** stored only as one-way hashes, with lockout after repeated wrong attempts.
- **Managers:** password login with optional two-factor authentication.
- **Venue devices:** branch devices are registered individually with their own cryptographic key, and can be removed if lost.
- **Least privilege:** server keys are kept server-side only. Apps carry only the public access key.
- **Backups:** nightly database backups, with encrypted off-site copies planned. Restore procedure documented.
- **Data minimisation:** no raw location stored. Clock-in photos auto-deleted. Quiz answers held server-side only.
- **Access control:** server access is limited to authorised personnel, using SSH keys.
- **Security review:** an independent security review is planned before general launch (scope prepared October 2026).

**[Solicitor]** Make sure every statement in this Annex is true at the date of signature. Update it as measures change, for example once off-site backups are live and the independent review is done.
