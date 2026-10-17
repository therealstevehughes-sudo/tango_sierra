// Billing v2 (2026-10-17) — per-branch staff-size bands. The server is the
// source of truth for what's actually charged (band_price_pence() /
// org_billing_quote() in tools/billing_v2_migration.sql); this mirror is
// for display only. Keep both — and the website calculator — in step.

enum BillingBand { bistro, brasserie, banquet, grand, empire }

class BandInfo {
  const BandInfo(this.band, this.name, this.size, this.maxStaff, this.pence);

  final BillingBand band;
  final String name;
  final String size;
  final int? maxStaff;
  final int? pence; // null = custom quote

  String get staffRange => switch (band) {
    BillingBand.bistro => '1–15',
    BillingBand.brasserie => '16–50',
    BillingBand.banquet => '51–150',
    BillingBand.grand => '151–300',
    BillingBand.empire => '300+',
  };
}

const billingBands = [
  BandInfo(BillingBand.bistro, 'Bistro', 'Small', 15, 3900),
  BandInfo(BillingBand.brasserie, 'Brasserie', 'Standard', 50, 5900),
  BandInfo(BillingBand.banquet, 'Banquet', 'Large', 150, 8900),
  BandInfo(BillingBand.grand, 'Grand', 'Extra large', 300, 12900),
  BandInfo(BillingBand.empire, 'Empire', 'Enterprise', null, null),
];

/// From 4 branches, head office is billed as one extra Bistro branch.
const headOfficeFromBranches = 4;

/// Yearly billing = 11 months' price (1 month free).
const yearlyMonths = 11;

BandInfo bandInfo(BillingBand band) =>
    billingBands.firstWhere((b) => b.band == band);

BillingBand bandFromName(String? name) => BillingBand.values.firstWhere(
  (b) => b.name == name,
  orElse: () => BillingBand.bistro,
);

String formatPounds(int pence) {
  final pounds = pence / 100;
  return pounds == pounds.roundToDouble()
      ? '£${pounds.toStringAsFixed(0)}'
      : '£${pounds.toStringAsFixed(2)}';
}

/// One branch in the server's quote.
class BranchQuote {
  const BranchQuote({
    required this.siteId,
    required this.name,
    required this.band,
    required this.pricePence,
  });

  final int siteId;
  final String name;
  final BillingBand band;
  final int pricePence;
}

/// The organisation's current price as calculated by the server
/// (my_billing_quote), before any discount.
class BillingQuote {
  const BillingQuote({
    required this.monthlyPence,
    required this.headOffice,
    required this.branches,
  });

  final int monthlyPence;
  final bool headOffice;
  final List<BranchQuote> branches;

  int discountedMonthlyPence(int discountPercent) =>
      (monthlyPence * (100 - discountPercent) / 100).round();
}
