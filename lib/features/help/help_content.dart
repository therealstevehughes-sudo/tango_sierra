/// First-pass Help content (2026-09-24) — real, editable copy rather than
/// a "coming soon" placeholder, per the user's own preference for a
/// working first draft over an empty stub. Plain const lists, same
/// pattern as `motivational_quotes.dart`: no CMS/backend exists for this,
/// and none is needed for content that changes rarely — a future editor
/// screen (if ever wanted) can read from a table instead without
/// touching any call site.
class HelpEntry {
  const HelpEntry(this.question, this.answer);

  final String question;
  final String answer;
}

const List<HelpEntry> faqEntries = [
  HelpEntry(
    'Who can see what I log?',
    'Your manager and anyone above them in your venue can see the tasks '
        'you complete. A named individual is never shown a graded score or '
        'league table - only a plain list of what they did and when.',
  ),
  HelpEntry(
    'What happens if I miss a task during my shift?',
    "It's recorded as not completed, not as a fail - an abandoned "
        'mid-shift task is expected, allowed behaviour, just never hidden. '
        'Your manager sees it as its own distinct status.',
  ),
  HelpEntry(
    'Can I go back and finish a task I skipped?',
    'Yes, any time before the end of your shift - it stays available in '
        'your task list until you complete it or your shift ends.',
  ),
  HelpEntry(
    'What if I fail a check (e.g. a fridge is too warm)?',
    "Log it as a FAIL, record the corrective action you took (or that you "
        "reported it), and add a photo if asked. This is exactly what the "
        "system is for - a logged FAIL with a fix is a success story for "
        "an inspector, not a problem for you.",
  ),
  HelpEntry(
    'Do I need to clock in and out separately from logging in?',
    "No - logging in with your PIN at the start of your shift is your "
        "clock-in. Use 'End shift' when you finish, which also shows you "
        "anything you still need to complete.",
  ),
  HelpEntry(
    'I raised an issue - what happens to it?',
    'It goes to your manager (or escalates further if not handled in '
        'time). You can check its status any time from "My Raised Issues."',
  ),
];

const List<HelpEntry> troubleshootingEntries = [
  HelpEntry(
    "My PIN isn't working",
    "Double check you're tapping your own name first, then entering the "
        "PIN - a wrong PIN on the right name gives a clear rejection "
        "message. If it still doesn't work, ask a manager to check your "
        "account is active and reset your PIN if needed.",
  ),
  HelpEntry(
    "A task I should have is missing from my list",
    "Ask your manager to check it's assigned to your role/section in "
        "Assign Tasks. Tasks only appear for the roles and departments "
        "they've been switched on for.",
  ),
  HelpEntry(
    "The app won't let me take a photo",
    "Make sure the app has camera permission (check your device "
        "settings). On Windows, if no camera is detected you'll be offered "
        "a file picker instead.",
  ),
  HelpEntry(
    "I can't submit a check / nothing happens when I press Submit",
    "This can happen if your organisation's account needs billing "
        "attention - you'll see a clear message if so. Otherwise, check "
        "every required field (including any photo) is filled in.",
  ),
  HelpEntry(
    "The app looks like it's stuck / frozen",
    "Try closing and reopening it. Your progress up to your last "
        "completed task is always saved as you go, so nothing already "
        "submitted is lost.",
  ),
  HelpEntry(
    "I'm not seeing the same tasks as yesterday",
    "That's expected if your schedule includes ad hoc tasks, or tasks "
        "tied to a time window - they only appear when due. Ask your "
        "manager if something looks genuinely wrong.",
  ),
];
