// Shift-welcome motivational lines (2026-09-24) -- shown once on the
// welcome screen after a successful login, picked at random. Short,
// genuine, workplace-appropriate -- never corny slogans, never
// performance-pressure ("be the best!"), matching this app's own
// even-handed tone elsewhere (see MetricChip's "never graded" rule).
const List<String> motivationalQuotes = [
  "Good shift today - one task at a time.",
  "Thanks for showing up. The team's better with you here.",
  "Small, steady work adds up to something real.",
  "Take care of the basics and the rest gets easier.",
  "Every check you do keeps someone else safe too.",
  "Slow is smooth, smooth is fast - no need to rush.",
  "A clean, honest shift is a good shift.",
  "You've got this. One task, then the next.",
  "Nice to see you. Let's have a good one.",
  "Consistency beats perfection - just keep going.",
];

String randomMotivationalQuote() {
  final index = DateTime.now().millisecondsSinceEpoch % motivationalQuotes.length;
  return motivationalQuotes[index];
}
