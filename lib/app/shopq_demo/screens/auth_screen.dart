import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routes/route_names.dart';
import '../state/demo_store.dart';
import '../widgets/micro_action_button.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  late final TabController _tabController;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _submitAuth(DemoStore store, {required bool isSignUp}) async {
    final success = await store.verifyOtp(
      phone: _phoneController.text,
      otpCode: _otpController.text,
      purpose: isSignUp ? 'register' : 'login',
      name: isSignUp ? _nameController.text : null,
    );

    if (!mounted) {
      return;
    }

    if (success) {
      store.clearError();
      Navigator.pushReplacementNamed(context, RouteNames.mainNavigation);
      return;
    }

    final message = store.lastErrorMessage ?? 'Authentication failed.';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _sendOtp(DemoStore store, {required bool isSignUp}) async {
    final otp = await store.requestOtp(
      phone: _phoneController.text,
      purpose: isSignUp ? 'register' : 'login',
    );

    if (!mounted) {
      return;
    }

    if (otp == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(store.lastErrorMessage ?? 'Unable to send OTP.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('OTP sent (demo): $otp'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DemoStore>(
      builder: (context, store, child) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: <Color>[Color(0xFF1D4ED8), Color(0xFF15803D)],
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Icon(CupertinoIcons.device_phone_portrait, color: Colors.white, size: 34),
                          const SizedBox(height: 10),
                          const Text(
                            'Welcome to ShopQ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Phone + OTP authentication only',
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Backend: ${store.apiBaseUrl}',
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    TabBar(
                      controller: _tabController,
                      tabs: const <Tab>[
                        Tab(text: 'Login'),
                        Tab(text: 'Sign Up'),
                      ],
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 360,
                      child: TabBarView(
                        controller: _tabController,
                        children: <Widget>[
                          _AuthForm(
                            isSignUp: false,
                            loading: store.isAuthLoading,
                            nameController: _nameController,
                            phoneController: _phoneController,
                            otpController: _otpController,
                            onSubmit: () => _submitAuth(store, isSignUp: false),
                            onSendOtp: () => _sendOtp(store, isSignUp: false),
                          ),
                          _AuthForm(
                            isSignUp: true,
                            loading: store.isAuthLoading,
                            nameController: _nameController,
                            phoneController: _phoneController,
                            otpController: _otpController,
                            onSubmit: () => _submitAuth(store, isSignUp: true),
                            onSendOtp: () => _sendOtp(store, isSignUp: true),
                          ),
                        ],
                      ),
                    ),
                    if ((store.lastOtpCode ?? '').trim().isNotEmpty) ...<Widget>[
                      const SizedBox(height: 8),
                      Text(
                        'Demo OTP: ${store.lastOtpCode}',
                        style: const TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.w700),
                      ),
                    ],
                    if ((store.lastErrorMessage ?? '').trim().isNotEmpty) ...<Widget>[
                      const SizedBox(height: 10),
                      Text(
                        store.lastErrorMessage!,
                        style: const TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.w600),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AuthForm extends StatelessWidget {
  const _AuthForm({
    required this.isSignUp,
    required this.loading,
    required this.nameController,
    required this.phoneController,
    required this.otpController,
    required this.onSubmit,
    required this.onSendOtp,
  });

  final bool isSignUp;
  final bool loading;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController otpController;
  final Future<void> Function() onSubmit;
  final Future<void> Function() onSendOtp;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (isSignUp) ...<Widget>[
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Full Name (optional)',
              prefixIcon: Icon(CupertinoIcons.person),
            ),
          ),
          const SizedBox(height: 14),
        ],
        TextField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            prefixIcon: Icon(CupertinoIcons.phone),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'OTP',
                  prefixIcon: Icon(CupertinoIcons.number),
                ),
              ),
            ),
            const SizedBox(width: 10),
            TextButton(
              onPressed: loading ? null : onSendOtp,
              child: const Text('Send OTP'),
            ),
          ],
        ),
        const SizedBox(height: 22),
        if (loading)
          const Center(
            child: CircularProgressIndicator(),
          )
        else
          MicroActionButton(
            label: isSignUp ? 'Verify & Create Account' : 'Verify & Login',
            icon: CupertinoIcons.arrow_right_circle_fill,
            onTap: onSubmit,
            expand: true,
          ),
        const SizedBox(height: 12),
        Text(
          'Demo mode: OTP is visible in response. Replace with SMS provider for production.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: const Color(0xFF64748B),
              ),
        ),
      ],
    );
  }
}
