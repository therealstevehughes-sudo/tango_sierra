// Terms of Service — in-app display copy (2026-09-27). Same convention as
// motivational_quotes.dart/help_content.dart: a plain const string, no CMS
// needed for content that changes rarely. This is the CUSTOMER-FACING
// text — the source document (legal/TERMS_OF_SERVICE.md, one level up in
// the repo) also carries internal ⚠️ solicitor-review notes that must
// never be shown here: presenting "this hasn't been legally reviewed yet"
// to someone being asked to legally agree to it would undermine the
// agreement itself, not just look unpolished.
//
// kTermsVersion MUST match tenant-signup's own CURRENT_TERMS_VERSION
// constant on the server (and legal/TERMS_OF_SERVICE.md's "Version:"
// line) — this is what's actually recorded against the organisation at
// signup, so the two must never drift apart silently.
const kTermsVersion = '2026-09-27';

const kTermsOfServiceText = '''
VenuRite Terms of Service
Version: $kTermsVersion

1. Who this agreement is with
These Terms of Service ("Terms") are a contract between you (the individual using the VenuRite application, or the business on whose behalf you use it) and VenuRite Ltd, a company registered in England and Wales.

By creating an account, signing in, or otherwise using the VenuRite application, you agree to be bound by these Terms. If you are using the App on behalf of a business, you confirm you have authority to bind that business.

2. What VenuRite is — and is not
VenuRite is a software tool that helps food businesses record, track, and manage day-to-day food hygiene and workplace safety compliance activity.

VenuRite is a record-keeping and workflow tool. It is not a substitute for your own legal duty to comply with food safety, health and safety, and all other applicable law; not a substitute for professional advice from a qualified Environmental Health Officer or food safety consultant; not a guarantee that your business complies with any law or will pass any inspection; and not a substitute for your own judgement, training, and supervision of staff.

You remain solely responsible for the actual safety of your food, premises, and operations, and for your own compliance with the law.

3. The AI assistant feature
The App may include an AI-powered assistant that answers questions using information drawn from published UK food safety and workplace guidance. Its answers are provided for general informational purposes only, may be incomplete or wrong, and are not professional advice. You are responsible for verifying anything it tells you before acting on it in a way that matters.

4. Accuracy of information
We make reasonable efforts to keep the App and its content accurate and up to date, but we do not warrant or guarantee that any information in the App is complete, current, or error-free. Independently verify any specific temperature, time limit, or other numeric threshold against the current official source before relying on it for a safety-critical decision.

5. Your responsibilities
You agree to provide accurate account information, use the App only for its intended compliance-record-keeping purpose, ensure records you log accurately reflect what actually happened, keep your login credentials and PINs secure, and independently comply with all applicable law regardless of what the App does or does not flag.

6. Availability
We aim to keep the App available but do not guarantee uninterrupted or error-free operation.

7. Limitation of liability
To the fullest extent permitted by law, VenuRite is not liable for loss or damage arising from errors or inaccuracies in the App's content or AI-generated answers, your reliance on the App instead of independent professional advice, your own error or failure to follow the law, or any food safety incident connected to your business's actual practices. Our total liability to you for any claim is capped at the fees you paid us in the preceding 12 months. Nothing in these Terms excludes liability for death or personal injury caused by our negligence, fraud, or anything else the law does not allow us to exclude.

8. Data and privacy
Our collection and use of your data is described in our separate Privacy Policy.

9. Changes to these Terms
We may update these Terms from time to time. Where we make a material change, we will ask you to accept the updated version before you can continue using the App.

10. Ending your access
We may suspend or end your access if you breach these Terms or your subscription lapses. You may stop using the App at any time.

11. Governing law
These Terms are governed by the law of England and Wales.

By ticking "I agree," you confirm that you have read, understood, and agree to be bound by these Terms.
''';
