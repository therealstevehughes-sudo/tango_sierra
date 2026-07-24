# DESIGN_SYSTEM_LOCK.md

## Purpose
This file prevents visual and interaction drift.

## Design Philosophy
This app must feel operational, fast, clean, strict, and confidence-building.

It must not feel playful, decorative, or overloaded.

## UX Rules
Staff screens:
- one primary action
- no clutter
- large controls
- minimal reading
- obvious pass/fail completion
- almost no typing

Manager screens:
- high visibility
- list and board control
- ability to drill in
- no decorative noise

Director screens:
- dashboards
- trend views
- red flags
- comparisons

## Layout Rules
- generous spacing
- clear hierarchy
- strong primary button
- consistent card structure
- no random layout experiments per screen

## Touch Rules
- large touch targets
- no tiny controls
- no hidden critical actions

## Colour Logic
Use colour for state, not decoration.

Suggested meaning:
- Green = completed / pass
- Amber = due soon / caution
- Red = failed / overdue / critical
- Blue = system / neutral action
- Grey = inactive / disabled

## Text Rules
- short labels
- no paragraphs on task screens
- no technical jargon for staff unless required
- keep wording operational

## Staff Task Screen Rule
Each staff task screen should contain:
- task title
- simple prompt
- input
- optional photo/evidence
- submit button

No extra menus.

## Manager Board Rule
Managers should see:
- who
- what
- status
- overdue items
- failed items
- reassign
- override
- sign-off

## Component Consistency Rule
Buttons, cards, chips, inputs, alerts, and status badges must use shared widgets where possible.

## Motion Rule
Use minimal motion.
Motion should support clarity, not style.

## Accessibility Rule
Support fast reading, simple controls, and clear visual contrast.

## Language Rule
The UI must remain readable when translated.
Avoid very long labels and fixed-width assumptions.

## Prohibited Drift
Do not introduce:
- random gradients everywhere
- gimmicky animation
- tiny icon-only critical actions
- crowded dashboards
- multiple competing button styles