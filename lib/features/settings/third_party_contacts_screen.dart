import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/management_drawer.dart';
import '../../core/widgets/primary_action_button.dart';
import '../../core/widgets/responsive_content.dart';
import '../../core/widgets/section_header.dart';
import '../../shared/models/third_party_contact.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/site_providers.dart';
import '../../shared/providers/third_party_contact_providers.dart';

class ThirdPartyContactsScreen extends ConsumerStatefulWidget {
  const ThirdPartyContactsScreen({super.key});

  @override
  ConsumerState<ThirdPartyContactsScreen> createState() =>
      _ThirdPartyContactsScreenState();
}

class _ThirdPartyContactsScreenState
    extends ConsumerState<ThirdPartyContactsScreen> {
  bool loading = true;
  List<ThirdPartyContact> contacts = [];

  bool showForm = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController specialtyController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    nameController.dispose();
    companyController.dispose();
    specialtyController.dispose();
    phoneController.dispose();
    emailController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final repo = ref.read(thirdPartyContactRepositoryProvider);
    final currentUser = ref.read(currentUserProvider);
    final siteId =
        ref.read(activeSiteProvider)?.id ??
        currentUser?.siteId ??
        (await ref.read(currentSiteProvider.future)).id;
    final loaded = await repo.getForSite(siteId);

    if (!mounted) return;
    setState(() {
      contacts = loaded;
      loading = false;
    });
  }

  Future<void> _saveContact() async {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();
    final currentUser = ref.read(currentUserProvider);
    if (name.isEmpty || currentUser == null) return;
    if (phone.isEmpty && email.isEmpty) return;

    final repo = ref.read(thirdPartyContactRepositoryProvider);
    await repo.create(
      name: name,
      company: companyController.text.trim().isEmpty
          ? null
          : companyController.text.trim(),
      specialty: specialtyController.text.trim().isEmpty
          ? null
          : specialtyController.text.trim(),
      phone: phone.isEmpty ? null : phone,
      email: email.isEmpty ? null : email,
      notes: notesController.text.trim().isEmpty
          ? null
          : notesController.text.trim(),
      siteId: currentUser.siteId,
      createdByUserId: currentUser.id,
    );

    if (!mounted) return;
    setState(() {
      showForm = false;
      nameController.clear();
      companyController.clear();
      specialtyController.clear();
      phoneController.clear();
      emailController.clear();
      notesController.clear();
    });
    await _loadData();
  }

  Future<void> _setActive(ThirdPartyContact contact, bool active) async {
    final repo = ref.read(thirdPartyContactRepositoryProvider);
    await repo.setActive(contact.id, active);
    await _loadData();
  }

  String _detailsLabel(ThirdPartyContact contact) {
    final parts = <String>[
      if (contact.company != null) contact.company!,
      if (contact.specialty != null) contact.specialty!,
      if (contact.phone != null) contact.phone!,
      if (contact.email != null) contact.email!,
    ];
    return parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Maintenance Contacts')),
      drawer: const ManagementDrawer(title: 'Maintenance Contacts'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ResponsiveContent(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (contacts.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text('No contacts added yet.'),
                    )
                  else
                    ...contacts.map(_buildContactTile),
                  const Divider(),
                  if (!showForm)
                    PrimaryActionButton(
                      label: 'Add Contact',
                      onPressed: () => setState(() => showForm = true),
                    )
                  else
                    _buildForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactTile(ThirdPartyContact contact) {
    return Card(
      child: ListTile(
        title: Text(contact.name),
        subtitle: Text(
          '${_detailsLabel(contact)}${contact.active ? '' : ' — inactive'}',
        ),
        trailing: TextButton(
          onPressed: () => _setActive(contact, !contact.active),
          child: Text(contact.active ? 'Deactivate' : 'Reactivate'),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        const SectionHeader(title: 'New Contact'),
        TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: companyController,
          decoration: const InputDecoration(labelText: 'Company (optional)'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: specialtyController,
          decoration: const InputDecoration(
            labelText: 'Specialty (e.g. Refrigeration, Electrical)',
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(labelText: 'Phone'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: notesController,
          decoration: const InputDecoration(labelText: 'Notes (optional)'),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'At least a phone number or email is required.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => setState(() => showForm = false),
              child: const Text('Cancel'),
            ),
            PrimaryActionButton(label: 'Save Contact', onPressed: _saveContact),
          ],
        ),
      ],
    );
  }
}
