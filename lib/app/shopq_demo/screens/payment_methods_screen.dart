import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/payment_method_item.dart';
import '../state/demo_store.dart';
import '../widgets/custom_app_bar.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DemoStore>().refreshPaymentMethods();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DemoStore>(
      builder: (context, store, child) {
        return Scaffold(
          appBar: const CustomAppBar(title: 'Payment Methods'),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _openForm(context, store),
            icon: const Icon(CupertinoIcons.add),
            label: const Text('Add Method'),
          ),
          body: RefreshIndicator(
            onRefresh: () => store.refreshPaymentMethods(),
            child: store.paymentMethods.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(24, 64, 24, 24),
                    children: <Widget>[
                      const Icon(
                        CupertinoIcons.creditcard,
                        size: 56,
                        color: Color(0xFF64748B),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No payment methods',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add UPI or card method.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
                    itemCount: store.paymentMethods.length,
                    itemBuilder: (context, index) {
                      final payment = store.paymentMethods[index];
                      return _PaymentCard(
                        payment: payment,
                        onEdit: () => _openForm(context, store, existing: payment),
                        onDelete: () => _deleteMethod(context, store, payment),
                        onSetDefault: payment.isDefault
                            ? null
                            : () async {
                                final success = await store.setDefaultPaymentMethod(payment.id);
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

  Future<void> _openForm(
    BuildContext context,
    DemoStore store, {
    PaymentMethodItem? existing,
  }) async {
    final success = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => _PaymentMethodFormSheet(existing: existing),
    );

    if (success != true || !context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(existing == null ? 'Payment method added.' : 'Payment method updated.'),
      ),
    );
  }

  Future<void> _deleteMethod(
    BuildContext context,
    DemoStore store,
    PaymentMethodItem method,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete payment method?'),
          content: Text('Remove "${method.label}"?'),
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

    final success = await store.deletePaymentMethod(method.id);
    if (!context.mounted || success) {
      return;
    }
    _showError(context, store.lastErrorMessage);
  }

  void _showError(BuildContext context, String? message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message ?? 'Something went wrong.')),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({
    required this.payment,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
  });

  final PaymentMethodItem payment;
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
              Icon(_iconForType(payment.type), color: const Color(0xFF1D4ED8)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  payment.label,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              if (payment.isDefault)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDBEAFE),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'Default',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1D4ED8),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(payment.displaySubtitle),
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

  IconData _iconForType(String type) {
    switch (type) {
      case 'card':
        return CupertinoIcons.creditcard_fill;
      case 'upi':
      default:
        return CupertinoIcons.qrcode;
    }
  }
}

class _PaymentMethodFormSheet extends StatefulWidget {
  const _PaymentMethodFormSheet({this.existing});

  final PaymentMethodItem? existing;

  @override
  State<_PaymentMethodFormSheet> createState() => _PaymentMethodFormSheetState();
}

class _PaymentMethodFormSheetState extends State<_PaymentMethodFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late String _type;
  late final TextEditingController _labelController;
  late final TextEditingController _holderController;
  late final TextEditingController _upiController;
  late final TextEditingController _cardLastFourController;
  late final TextEditingController _cardNetworkController;
  late final TextEditingController _expiryMonthController;
  late final TextEditingController _expiryYearController;
  bool _isDefault = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    final existingType = existing?.type ?? 'upi';
    _type = existingType == 'card' ? 'card' : 'upi';
    _labelController = TextEditingController(text: existing?.label ?? '');
    _holderController = TextEditingController(text: existing?.holderName ?? '');
    _upiController = TextEditingController(text: existing?.upiId ?? '');
    _cardLastFourController = TextEditingController(text: existing?.cardLastFour ?? '');
    _cardNetworkController = TextEditingController(text: existing?.cardNetwork ?? '');
    _expiryMonthController = TextEditingController(text: existing?.expiryMonth?.toString() ?? '');
    _expiryYearController = TextEditingController(text: existing?.expiryYear?.toString() ?? '');
    _isDefault = existing?.isDefault ?? false;
  }

  @override
  void dispose() {
    _labelController.dispose();
    _holderController.dispose();
    _upiController.dispose();
    _cardLastFourController.dispose();
    _cardNetworkController.dispose();
    _expiryMonthController.dispose();
    _expiryYearController.dispose();
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
                isEdit ? 'Edit Payment Method' : 'Add Payment Method',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 12),
              SegmentedButton<String>(
                segments: const <ButtonSegment<String>>[
                  ButtonSegment<String>(value: 'upi', icon: Icon(CupertinoIcons.qrcode), label: Text('UPI')),
                  ButtonSegment<String>(value: 'card', icon: Icon(CupertinoIcons.creditcard), label: Text('Card')),
                ],
                selected: <String>{_type},
                onSelectionChanged: (selection) {
                  setState(() => _type = selection.first);
                },
              ),
              const SizedBox(height: 10),
              _FormField(controller: _labelController, label: 'Label'),
              _FormField(controller: _holderController, label: 'Holder Name', isRequired: false),
              if (_type == 'upi')
                _FormField(controller: _upiController, label: 'UPI ID')
              else if (_type == 'card') ...<Widget>[
                _FormField(
                  controller: _cardLastFourController,
                  label: 'Card Last 4 Digits',
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                ),
                _FormField(controller: _cardNetworkController, label: 'Card Network'),
                _FormField(
                  controller: _expiryMonthController,
                  label: 'Expiry Month',
                  keyboardType: TextInputType.number,
                  maxLength: 2,
                ),
                _FormField(
                  controller: _expiryYearController,
                  label: 'Expiry Year',
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                ),
              ],
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                value: _isDefault,
                onChanged: (value) => setState(() => _isDefault = value),
                title: const Text('Set as default payment method'),
              ),
              const SizedBox(height: 8),
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
                      : Text(isEdit ? 'Update Method' : 'Create Method'),
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
        ? await store.createPaymentMethod(
            type: _type,
            label: _labelController.text,
            holderName: _holderController.text,
            upiId: _upiController.text,
            cardLastFour: _cardLastFourController.text,
            cardNetwork: _cardNetworkController.text,
            expiryMonth: int.tryParse(_expiryMonthController.text),
            expiryYear: int.tryParse(_expiryYearController.text),
            isDefault: _isDefault,
          )
        : await store.updatePaymentMethod(
            id: existing.id,
            type: _type,
            label: _labelController.text,
            holderName: _holderController.text,
            upiId: _upiController.text,
            cardLastFour: _cardLastFourController.text,
            cardNetwork: _cardNetworkController.text,
            expiryMonth: int.tryParse(_expiryMonthController.text),
            expiryYear: int.tryParse(_expiryYearController.text),
            isDefault: _isDefault,
          );

    if (!mounted) {
      return;
    }

    setState(() => _isSubmitting = false);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(store.lastErrorMessage ?? 'Unable to save payment method.')),
      );
      return;
    }

    Navigator.pop(context, true);
  }
}

class _FormField extends StatelessWidget {
  const _FormField({
    required this.controller,
    required this.label,
    this.isRequired = true,
    this.keyboardType,
    this.maxLength,
  });

  final TextEditingController controller;
  final String label;
  final bool isRequired;
  final TextInputType? keyboardType;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLength: maxLength,
        decoration: InputDecoration(labelText: label),
        validator: (value) {
          final text = (value ?? '').trim();
          if (isRequired && text.isEmpty) {
            return 'Required';
          }
          return null;
        },
      ),
    );
  }
}
