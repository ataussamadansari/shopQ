import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../routes/route_names.dart';
import '../widgets/micro_action_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const List<_OnboardingPage> _pages = <_OnboardingPage>[
    _OnboardingPage(
      icon: CupertinoIcons.sparkles,
      title: 'Curated shopping experience',
      subtitle: 'Discover featured picks, flash sales, and personalized categories in one flow.',
      color: Color(0xFF1D4ED8),
    ),
    _OnboardingPage(
      icon: CupertinoIcons.cart_fill_badge_plus,
      title: 'Fast cart and checkout',
      subtitle: 'Review your cart, update quantities, and complete checkout with smooth transitions.',
      color: Color(0xFF15803D),
    ),
    _OnboardingPage(
      icon: CupertinoIcons.cube_box_fill,
      title: 'Track every order',
      subtitle: 'Follow each order stage from confirmation to delivery through a simple status timeline.',
      color: Color(0xFF0F172A),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToAuth() {
    Navigator.pushReplacementNamed(context, RouteNames.auth);
  }

  void _onNext() {
    if (_currentPage == _pages.length - 1) {
      _goToAuth();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _goToAuth,
                  child: const Text('Skip'),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    final item = _pages[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 320),
                          tween: Tween<double>(begin: 0.9, end: 1),
                          curve: Curves.easeOutBack,
                          builder: (context, value, child) => Transform.scale(
                            scale: value,
                            child: child,
                          ),
                          child: Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              color: item.color.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(36),
                            ),
                            child: Icon(item.icon, size: 84, color: item.color),
                          ),
                        ),
                        const SizedBox(height: 36),
                        Text(
                          item.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          item.subtitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: const Color(0xFF475569),
                              ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List<Widget>.generate(
                  _pages.length,
                  (index) => AnimatedContainer(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    duration: const Duration(milliseconds: 220),
                    width: _currentPage == index ? 26 : 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? Theme.of(context).colorScheme.primary
                          : const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              MicroActionButton(
                label: _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                icon: CupertinoIcons.arrow_right,
                onTap: _onNext,
                expand: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage {
  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
}
