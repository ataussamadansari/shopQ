import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routes/route_names.dart';
import '../state/demo_store.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _boot();
    });
  }

  Future<void> _boot() async {
    await context.read<DemoStore>().finishSplashLoad();
    if (!mounted) {
      return;
    }
    Navigator.pushReplacementNamed(context, RouteNames.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Color(0xFF0F172A),
              Color(0xFF1D4ED8),
              Color(0xFF15803D),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.75, end: 1),
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeOutBack,
                builder: (context, scale, child) {
                  return Transform.scale(scale: scale, child: child);
                },
                child: Container(
                  width: 92,
                  height: 92,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: const Icon(
                    CupertinoIcons.bag_fill,
                    color: Color(0xFF15803D),
                    size: 48,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'ShopQ',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                  fontSize: 32,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Shop smarter. Demo faster.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.85),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 28),
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
