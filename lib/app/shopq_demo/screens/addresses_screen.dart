import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/address_item.dart';
import '../state/demo_store.dart';
import '../widgets/custom_app_bar.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DemoStore>().refreshAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DemoStore>(
      builder: (context, store, child) {
        return Scaffold(
          appBar: const CustomAppBar(title: 'Saved Addresses'),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _openAddressForm(context, store),
            icon: const Icon(CupertinoIcons.add),
            label: const Text('Add Address'),
          ),
          body: RefreshIndicator(
            onRefresh: () => store.refreshAddresses(),
            child: store.addressItems.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(24, 64, 24, 24),
                    children: <Widget>[
                      const Icon(
                        CupertinoIcons.location_slash,
                        size: 58,
                        color: Color(0xFF64748B),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'No addresses yet',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add your first address to continue checkout.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
                    itemCount: store.addressItems.length,
                    itemBuilder: (context, index) {
                      final address = store.addressItems[index];
                      return _AddressCard(
                        address: address,
                        onEdit: () => _openAddressForm(context, store, existing: address),
                        onDelete: () => _deleteAddress(context, store, address),
                        onSetDefault: address.isDefault
                            ? null
                            : () async {
                                final success = await store.setDefaultAddress(address.id);
                                if (!context.mounted || success) {
                                  return;
                                }
                                _showError(context, store.lastErrorMessage);
                              },
                      );
                    },
                  ),
          ),
        );
      },
    );
  }

  Future<void> _deleteAddress(
    BuildContext context,
    DemoStore store,
    AddressItem address,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete address?'),
          content: Text('Remove "${address.label}" from saved addresses?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    final success = await store.deleteAddress(address.id);
    if (!context.mounted || success) {
      return;
    }
    _showError(context, store.lastErrorMessage);
  }

  Future<void> _openAddressForm(
    BuildContext context,
    DemoStore store, {
    AddressItem? existing,
  }) async {
    final success = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => _AddressFormSheet(existing: existing),
    );

    if (success != true || !context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(existing == null ? 'Address created.' : 'Address updated.'),
      ),
    );
  }

  void _showError(BuildContext context, String? message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message ?? 'Something went wrong.')),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({
    required this.address,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
  });

  final AddressItem address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onSetDefault;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                address.label,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(width: 8),
              if (address.isDefault)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'Default',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF15803D),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(address.recipientName),
          Text(address.phone),
          const SizedBox(height: 6),
          Text(address.displayLabel),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: <Widget>[
              OutlinedButton.icon(
                onPressed: onEdit,
                icon: const Icon(CupertinoIcons.pencil, size: 16),
                label: const Text('Edit'),
              ),
              OutlinedButton.icon(
                onPressed: onDelete,
                icon: const Icon(CupertinoIcons.delete, size: 16),
                label: const Text('Delete'),
              ),
              if (onSetDefault != null)
                FilledButton.tonalIcon(
                  onPressed: onSetDefault,
                  icon: const Icon(CupertinoIcons.check_mark, size: 16),
                  label: const Text('Set Default'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AddressFormSheet extends StatefulWidget {
  const _AddressFormSheet({this.existing});

  final AddressItem? existing;

  @override
  State<_AddressFormSheet> createState() => _AddressFormSheetState();
}

class _AddressFormSheetState extends State<_AddressFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _labelController;
  late final TextEditingController _recipientController;
  late final TextEditingController _phoneController;
  late final TextEditingController _line1Controller;
  late final TextEditingController _line2Controller;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _postalController;
  late final TextEditingController _countryController;
  bool _isDefault = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _labelController = TextEditingController(text: existing?.label ?? '');
    _recipientController = TextEditingController(text: existing?.recipientName ?? '');
    _phoneController = TextEditingController(text: existing?.phone ?? '');
    _line1Controller = TextEditingController(text: existing?.line1 ?? '');
    _line2Controller = TextEditingController(text: existing?.line2 ?? '');
    _cityController = TextEditingController(text: existing?.city ?? '');
    _stateController = TextEditingController(text: existing?.state ?? '');
    _postalController = TextEditingController(text: existing?.postalCode ?? '');
    _countryController = TextEditingController(text: existing?.country ?? 'India');
    _isDefault = existing?.isDefault ?? false;
  }

  @override
  void dispose() {
    _labelController.dispose();
    _recipientController.dispose();
    _phoneController.dispose();
    _line1Controller.dispose();
    _line2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16 + bottomInset),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                isEdit ? 'Edit Address' : 'Add Address',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 12),
              _Field(controller: _labelController, label: 'Label (Home, Office)'),
              _Field(controller: _recipientController, label: 'Recipient Name'),
              _Field(controller: _phoneController, label: 'Phone', keyboardType: TextInputType.phone),
              _Field(controller: _line1Controller, label: 'Address Line 1'),
              _Field(controller: _line2Controller, label: 'Address Line 2 (Optional)', isRequired: false),
              _Field(controller: _cityController, label: 'City'),
              _Field(controller: _stateController, label: 'State'),
              _Field(controller: _postalController, label: 'Postal Code'),
              _Field(controller: _countryController, label: 'Country'),
              const SizedBox(height: 4),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                value: _isDefault,
                onChanged: (value) => setState(() => _isDefault = value),
                title: const Text('Set as default address'),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(isEdit ? 'Update Address' : 'Create Address'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _isSubmitting = true);
    final store = context.read<DemoStore>();
    final existing = widget.existing;

    final success = existing == null
        ? await store.createAddress(
            label: _labelController.text,
            recipientName: _recipientController.text,
            phone: _phoneController.text,
            line1: _line1Controller.text,
            line2: _line2Controller.text,
            city: _cityController.text,
            state: _stateController.text,
            postalCode: _postalController.text,
            country: _countryController.text,
            isDefault: _isDefault,
          )
        : await store.updateAddress(
            id: existing.id,
            label: _labelController.text,
            recipientName: _recipientController.text,
            phone: _phoneController.text,
            line1: _line1Controller.text,
            line2: _line2Controller.text,
            city: _cityController.text,
            state: _stateController.text,
            postalCode: _postalController.text,
            country: _countryController.text,
            isDefault: _isDefault,
          );

    if (!mounted) {
      return;
    }

    setState(() => _isSubmitting = false);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(store.lastErrorMessage ?? 'Unable to save address.')),
      );
      return;
    }

    Navigator.pop(context, true);
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    this.isRequired = true,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final bool isRequired;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(labelText: label),
        validator: isRequired
            ? (value) {
                if ((value ?? '').trim().isEmpty) {
                  return 'Required';
                }
                return null;
              }
            : null,
      ),
    );
  }
}
