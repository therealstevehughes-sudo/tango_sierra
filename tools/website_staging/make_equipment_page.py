import re
import sys

partners_path, out_path = sys.argv[1], sys.argv[2]
p = open(partners_path, encoding='utf8').read()

GROUPS = [
    ('Refrigeration & cold storage', ['Fridge', 'Freezer', 'Walk-in Fridge', 'Walk-in Freezer', 'Blast Chiller',
        'Prep Fridge', 'Undercounter Fridge', 'Serve-Over Fridge', 'Refrigerated Display Case', 'Back-Bar Fridge',
        'Gelato Dipping Cabinet']),
    ('Cooking', ['Oven', 'Deck Oven', 'Conveyor Oven', 'Pizza Oven', 'Grill', 'Salamander', 'Griddle', 'Hob',
        'Induction Hob', 'Wok Range', 'Fryer', 'Pressure Fryer', 'Bratt Pan', 'Boiling Pan', 'Steamer',
        'Rotisserie', 'Kebab Machine', 'Microwave', 'Sous-Vide Bath', 'Soup Kettle', 'Proving Cabinet']),
    ('Hot holding & service', ['Hot-hold unit', 'Bain-marie', 'Heated Gantry']),
    ('Food preparation', ['Prep Station', 'Food Processor', 'Planetary Mixer', 'Slicer', 'Mincer', 'Dough Sheeter',
        'Blender', 'Vacuum Packer', 'Juicer']),
    ('Warewashing & hygiene', ['Dishwasher', 'Conveyor Dishwasher', 'Glasswasher', 'Pot Wash Sink', 'Hand-Wash Sink']),
    ('Bar & beverages', ['Coffee Machine', 'Filter Brewer', 'Water Boiler', 'Post-Mix System', 'Cellar Cooler',
        'Keg System', 'Ice Machine', 'Slush Machine']),
    ('Building, safety & storage', ['Extraction Canopy', 'Grease Trap', 'Gas Interlock System',
        'Fire Suppression System', 'Dry Store Area', 'Chemical Store']),
]

seed = open(sys.argv[3], encoding='utf8').read()
names = set(n.replace("''", "'") for n in re.findall(
    r"insert into equipment_types \(id, name, organisation_id\) values \(\d+, '((?:[^']|'')*)', null\)", seed))
grouped = [n for _, items in GROUPS for n in items]
assert set(grouped) == names, (names - set(grouped), set(grouped) - names)
assert len(grouped) == len(set(grouped))

head = p[: p.index('</head>')]
head = head.replace('<title>VenuRite Partners</title>', '<title>Supported Equipment</title>')
head = re.sub(r'<meta name="description" content="[^"]*" />',
              '<meta name="description" content="Every piece of kitchen, bar and building equipment VenuRite has checks for." />',
              head)
head = head.replace('href="https://venurite.com/partners/"', 'href="https://venurite.com/equipmentlist/"')

css = '''<style>
  .eq-hero { padding: 72px 0 12px; text-align: center; }
  .eq-hero h1 { font-family: "Fraunces", serif; font-size: clamp(2rem, 4vw, 2.8rem); line-height: 1.15; margin: 10px 0 12px; }
  .eq-hero p { color: var(--muted); max-width: 640px; margin: 0 auto; font-size: 1.05rem; }
  .eq-count { display: inline-block; margin-top: 16px; padding: 6px 14px; border-radius: 999px; background: var(--teal-tint); color: var(--teal-ink); font-weight: 700; font-size: 0.9rem; }
  .eq-search { display: block; width: 100%; max-width: 420px; margin: 28px auto 0; padding: 12px 16px; border: 1px solid var(--line-strong); border-radius: 12px; background: var(--card); color: var(--ink); font: inherit; }
  .eq-groups { max-width: 980px; margin: 32px auto 0; display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 18px; }
  .eq-group { background: var(--card); border: 1px solid var(--line); border-radius: 18px; padding: 22px; box-shadow: var(--shadow); }
  .eq-group h2 { font-family: "Fraunces", serif; font-size: 1.15rem; margin: 0 0 12px; }
  .eq-group ul { list-style: none; margin: 0; padding: 0; display: flex; flex-wrap: wrap; gap: 8px; }
  .eq-group li { padding: 6px 12px; border-radius: 999px; background: var(--paper); border: 1px solid var(--line); font-size: 0.88rem; }
  .eq-group[hidden], .eq-group li[hidden] { display: none; }
  .eq-none { text-align: center; color: var(--muted); margin-top: 24px; }
  .eq-cta { max-width: 640px; margin: 40px auto 72px; text-align: center; background: var(--teal-tint); border: 1px dashed var(--line-strong); border-radius: 18px; padding: 28px; }
  .eq-cta h2 { font-family: "Fraunces", serif; font-size: 1.35rem; margin: 0 0 8px; }
  .eq-cta p { color: var(--muted); margin: 0 0 18px; }
</style>
'''

groups_html = ''.join(
    '    <section class="eq-group">\n      <h2>%s</h2>\n      <ul>%s</ul>\n    </section>\n' % (
        title.replace('&', '&amp;'),
        ''.join('<li>%s</li>' % n for n in items))
    for title, items in GROUPS)

body = '''
<header class="site">
  <div class="wrap nav-row">
    <a class="brand" href="/">
      <img src="/images/VenuRite_long.png" alt="VenuRite" />
    </a>
    <nav class="links">
      <a href="/#features">Features</a>
      <a href="/#how-it-works">How it works</a>
      <a href="/#pricing">Pricing</a>
      <a href="/#faq">FAQ</a>
      <a href="/partners/">Partners</a>
    </nav>
    <a class="btn btn-primary" href="/#pricing">Get started</a>
  </div>
</header>

<div class="wrap">
  <section class="eq-hero">
    <span class="kicker">Equipment</span>
    <h1>Equipment VenuRite supports</h1>
    <p>Add any of these to your venue and VenuRite knows how to look after it - from fridge temperatures to fryer oil and fire safety kit.</p>
    <span class="eq-count">COUNT pieces of equipment, and growing</span>
    <input class="eq-search" id="eqSearch" type="search" placeholder="Search equipment, e.g. fryer" aria-label="Search equipment">
  </section>

  <div class="eq-groups" id="eqGroups">
GROUPS  </div>
  <p class="eq-none" id="eqNone" hidden>No match - tell us what you use below and we'll add it.</p>

  <section class="eq-cta">
    <h2>Don't see your equipment?</h2>
    <p>We're adding new equipment all the time. Tell us what you've got and we'll build the checks for it.</p>
    <a class="btn btn-primary" href="mailto:hello@venurite.com?subject=Equipment request">Request equipment</a>
  </section>
</div>

<footer class="site">
  <div class="wrap">
    <div class="footer-row">
      <a class="brand" href="/"><img src="/images/VenuRite_long.png" alt="VenuRite" style="height:22px;width:auto;" /></a>
      <div class="footer-links">
        <a href="/#features">Features</a>
        <a href="/#pricing">Pricing</a>
        <a href="/equipmentlist/">Equipment</a>
        <a href="/partners/">Partners</a>
        <a href="mailto:hello@venurite.com">Contact</a>
      </div>
    </div>
    <div class="copyright">&copy; 2026 VenuRite Ltd. All rights reserved.</div>
  </div>
</footer>
<script>
(function () {
  var input = document.getElementById('eqSearch');
  var groups = document.querySelectorAll('.eq-group');
  var none = document.getElementById('eqNone');
  input.addEventListener('input', function () {
    var q = input.value.trim().toLowerCase();
    var any = false;
    groups.forEach(function (g) {
      var shown = 0;
      g.querySelectorAll('li').forEach(function (li) {
        var hit = !q || li.textContent.toLowerCase().indexOf(q) !== -1;
        li.hidden = !hit;
        if (hit) shown++;
      });
      g.hidden = shown === 0;
      if (shown) any = true;
    });
    none.hidden = any;
  });
})();
</script>
'''.replace('COUNT', str(len(grouped))).replace('GROUPS', groups_html)

open(out_path, 'w', encoding='utf8').write(head + css + '</head>\n<body>' + body + '</body>\n</html>\n')
print('ok', len(grouped))
