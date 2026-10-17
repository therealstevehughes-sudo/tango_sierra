"""Second-pass review of the quiz bank against the guides (2026-10-17).

Every number in a right answer must appear in that task's own guide, and
no wrong answer may use only the right answer's numbers (which would make
it arguably right too). Prints anything that needs a human look.

    python tools/quiz/cross_check_numbers.py
"""
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import build_quiz_seed as b  # noqa: E402

# Numbers on their own, not part of a name like CO2 or L8.
NUM = re.compile(r'(?<![A-Za-z])-?\d+(?:\.\d+)?')

# Wrong answers that deliberately reuse the guide's number but get the
# rest wrong (checked by hand, 2026-10-17).
REVIEWED_TRAPS = {
    'At -18°C all bacteria are killed',          # guide: growth stops
    'About 5cm (a matchbox thick)',              # guide: about 5mm
    '999 only',                                  # guide: 0800 111 999
    '25ml and 35ml together',                    # guide: one or the other
    '3-5 weeks', '3-5 months',                   # guide: 3-5 days
    '4 hours for hot, 2 hours for cold',         # guide: the other way round
}


def guide_blocks():
    src = open(b.GUIDES, encoding='utf8').read()
    consts = {m.group(1): m.group(2) for m in re.finditer(
        r"const (_\w+) =\s*'((?:[^'\\]|\\.)*)';", src, re.S)}
    blocks = {}
    for m in re.finditer(
            r"^  (?:'((?:[^'\\]|\\.)*)'|\"([^\"]*)\"): _g\((.*?)\n  \),",
            src, re.M | re.S):
        title = (m.group(1) if m.group(1) is not None else m.group(2)).replace("\\'", "'")
        body = m.group(3)
        for k, v in consts.items():
            body = body.replace(k, v)
        blocks[title] = body
    return blocks


def main():
    blocks = guide_blocks()
    banks, _ = b.parse_banks()
    issues = 0
    for title, qs in banks.items():
        guide_nums = set(NUM.findall(blocks.get(title, '')))
        for q in qs:
            right_nums = set(NUM.findall(q['right'][0]))
            missing = sorted(n for n in right_nums if n not in guide_nums)
            if missing:
                issues += 1
                print(f'RIGHT ANSWER NUMBER NOT IN GUIDE  {title} | {q["q"]} | {q["right"][0]} {missing}')
            for w in q['wrong']:
                wrong_nums = set(NUM.findall(w))
                if wrong_nums and wrong_nums <= right_nums and w not in REVIEWED_TRAPS:
                    issues += 1
                    print(f'WRONG ANSWER SHARES THE NUMBERS  {title} | {q["q"]} | {w}')
    print(f'{len(blocks)} guides, {issues} to review')
    sys.exit(1 if issues else 0)


if __name__ == '__main__':
    main()
