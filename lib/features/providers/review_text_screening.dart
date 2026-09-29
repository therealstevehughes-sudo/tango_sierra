// Review text screening, layer 1 of 2 (2026-09-29, agreed with the
// founder) — a plain regex pass for phone numbers/emails/URLs, checked
// before a review ever reaches the server; the reviewer is asked to
// remove the identifying detail rather than having it silently
// auto-redacted, keeping the review in their own words.
//
// Layer 2 (an LLM pass checking whether the text names the business
// itself, which a phone/email/URL regex can never catch) was agreed as
// worth doing but deliberately NOT built this pass — it needs wiring
// into the existing ai-assistant OpenAI setup as its own piece of work.
//
// Pure function, no I/O — easily unit tested directly on a string, same
// reasoning as this app's other compute-only helpers (e.g.
// equipment_trend_service.dart).
final _phonePattern = RegExp(r'(\+?\d[\d\s-]{7,}\d)');
final _emailPattern = RegExp(r'[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}');
final _urlPattern = RegExp(r'(https?://|www\.)\S+');

/// Returns a short description of the first kind of identifying info
/// found in [text] (e.g. `'a phone number'`), or null if none is found.
String? identifyingInfoIn(String text) {
  if (_phonePattern.hasMatch(text)) return 'a phone number';
  if (_emailPattern.hasMatch(text)) return 'an email address';
  if (_urlPattern.hasMatch(text)) return 'a web address';
  return null;
}
