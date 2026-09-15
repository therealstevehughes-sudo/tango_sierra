import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as gotrue;

import '../../core/widgets/app_banner.dart';
import '../../core/widgets/management_drawer.dart';
import '../../core/widgets/responsive_content.dart';

// Two-factor authentication for senior (regional/executive) GoTrue
// accounts (roadmap v1.1, built 2026-09-15) — the "planned fast-follow"
// senior_login_screen.dart's own doc comment already named. Uses
// Supabase's native TOTP MFA (auth.mfa.*) — no external SMS/push service
// needed, this backend already supports it. PIN-tier accounts (base
// through venueManager) never touch GoTrue's own auth at all (see
// currentSessionTokenProvider's doc comment), so this only ever applies
// to regional/executive.
//
// The QR is rendered from the enrollment's own otpauth:// URI via
// qr_flutter (already a dependency, used elsewhere for invite codes) --
// simpler than trying to display GoTrue's own SVG QR code, which would
// need an SVG renderer this app doesn't otherwise depend on.
class TwoFactorSettingsScreen extends StatefulWidget {
  const TwoFactorSettingsScreen({super.key});

  @override
  State<TwoFactorSettingsScreen> createState() =>
      _TwoFactorSettingsScreenState();
}

class _TwoFactorSettingsScreenState extends State<TwoFactorSettingsScreen> {
  bool _loading = true;
  gotrue.Factor? _verifiedFactor;

  // Enrollment-in-progress state — cleared once confirmed or cancelled.
  gotrue.AuthMFAEnrollResponse? _pendingEnrollment;
  final _codeController = TextEditingController();
  String? _error;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final factors = await gotrue.Supabase.instance.client.auth.mfa
        .listFactors();
    if (!mounted) return;
    setState(() {
      _verifiedFactor = factors.totp.firstOrNull;
      _loading = false;
    });
  }

  Future<void> _startEnroll() async {
    setState(() {
      _error = null;
      _submitting = true;
    });
    try {
      final response = await gotrue.Supabase.instance.client.auth.mfa.enroll(
        factorType: gotrue.FactorType.totp,
      );
      if (!mounted) return;
      setState(() {
        _pendingEnrollment = response;
        _submitting = false;
      });
    } on gotrue.AuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _submitting = false;
      });
    }
  }

  Future<void> _confirmEnroll() async {
    final enrollment = _pendingEnrollment;
    final code = _codeController.text.trim();
    if (enrollment == null || code.isEmpty) return;

    setState(() {
      _error = null;
      _submitting = true;
    });
    try {
      await gotrue.Supabase.instance.client.auth.mfa.challengeAndVerify(
        factorId: enrollment.id,
        code: code,
      );
      if (!mounted) return;
      setState(() {
        _pendingEnrollment = null;
        _codeController.clear();
        _submitting = false;
      });
      await _load();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Two-factor authentication is now on.')),
      );
    } on gotrue.AuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _submitting = false;
      });
    }
  }

  Future<void> _cancelEnroll() async {
    final enrollment = _pendingEnrollment;
    setState(() {
      _pendingEnrollment = null;
      _codeController.clear();
      _error = null;
    });
    // Best-effort cleanup — the unverified factor is harmless if this
    // fails (it never reaches aal2 and GoTrue itself prunes unverified
    // factors), so this isn't guarded any more strictly than that.
    if (enrollment != null) {
      try {
        await gotrue.Supabase.instance.client.auth.mfa.unenroll(
          enrollment.id,
        );
      } catch (_) {}
    }
  }

  Future<void> _turnOff() async {
    final factor = _verifiedFactor;
    if (factor == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Turn off two-factor authentication?'),
        content: const Text(
          'This account will sign in with just a password again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Turn Off'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _submitting = true);
    await gotrue.Supabase.instance.client.auth.mfa.unenroll(factor.id);
    if (!mounted) return;
    setState(() => _submitting = false);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Two-Factor Authentication')),
      drawer: const ManagementDrawer(title: 'Two-Factor Authentication'),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ResponsiveContent(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _pendingEnrollment != null
                    ? _buildEnrollStep()
                    : _buildStatus(),
              ),
            ),
    );
  }

  Widget _buildStatus() {
    final on = _verifiedFactor != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppBanner(
          kind: on ? BannerKind.info : BannerKind.caution,
          child: Text(
            on
                ? 'Two-factor authentication is ON for this account.'
                : 'Two-factor authentication is OFF — add it for an extra '
                      'layer of protection on this senior account.',
          ),
        ),
        const SizedBox(height: 20),
        if (on)
          ElevatedButton(
            onPressed: _submitting ? null : _turnOff,
            child: const Text('Turn Off'),
          )
        else
          ElevatedButton(
            onPressed: _submitting ? null : _startEnroll,
            child: const Text('Enable Two-Factor Authentication'),
          ),
      ],
    );
  }

  Widget _buildEnrollStep() {
    final enrollment = _pendingEnrollment!;
    final totp = enrollment.totp!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Scan this with your authenticator app (Google Authenticator, '
          'Authy, etc.), then enter the 6-digit code it shows.',
        ),
        const SizedBox(height: 16),
        Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: QrImageView(data: totp.uri, size: 200, backgroundColor: Colors.white),
          ),
        ),
        const SizedBox(height: 12),
        const Text('Can\'t scan? Enter this code manually:'),
        const SizedBox(height: 4),
        SelectableText(
          totp.secret,
          style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _codeController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: '6-digit code'),
          onSubmitted: (_) => _confirmEnroll(),
        ),
        if (_error != null) ...[
          const SizedBox(height: 12),
          Text(
            _error!,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.error),
          ),
        ],
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _submitting ? null : _cancelEnroll,
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _submitting ? null : _confirmEnroll,
                child: _submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Confirm'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
