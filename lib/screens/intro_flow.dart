import 'dart:async';

import 'package:flutter/material.dart';

import '../services/database_service.dart';

class IntroFlow extends StatefulWidget {
  const IntroFlow({super.key, required this.onFinished});

  final VoidCallback onFinished;

  @override
  State<IntroFlow> createState() => _IntroFlowState();
}

class _IntroFlowState extends State<IntroFlow> {
  static const Color _background = Color(0xFF123F3D);
  static const Color _panel = Color(0xFF00645E);
  static const Color _mint = Color(0xFFB9FFD0);

  final PageController _pageController = PageController();
  int _page = 0;
  bool _checking = true;

  final List<_IntroPageData> _pages = const [
    _IntroPageData(
      title: 'Track Expenses\nwith Ease',
      description:
          'Stay on top of your spending with real-time tracking, easy categorization, and instant updates for the whole group.',
      icon: Icons.query_stats_rounded,
      accent: Color(0xFF62E79A),
    ),
    _IntroPageData(
      title: 'Achieve Savings\nGoals as a Team',
      description:
          'Share goals and track progress with visual milestones. Make it easy to save for trips, emergency funds, and more.',
      icon: Icons.savings_rounded,
      accent: Color(0xFFFFC65C),
    ),
    _IntroPageData(
      title: 'Your Data, Secure\nand Private',
      description:
          'Your transactions stay stored locally on your device, giving you control over your personal finance information.',
      icon: Icons.shield_rounded,
      accent: Color(0xFF62E79A),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    try {
      final seen = await DatabaseService.instance.hasCompletedIntro();
      if (!mounted) return;
      if (seen) {
        widget.onFinished();
        return;
      }
    } catch (_) {
      // If the local settings cannot be read, keep the intro accessible.
    }
    if (mounted) {
      await Future<void>.delayed(const Duration(milliseconds: 900));
      if (mounted) setState(() => _checking = false);
    }
  }

  Future<void> _finish() async {
    try {
      await DatabaseService.instance.setIntroCompleted();
    } catch (_) {
      // Intro can still finish if saving the preference fails.
    }
    if (mounted) widget.onFinished();
  }

  void _next() {
    if (_page < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    } else {
      _finish();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return Scaffold(
        backgroundColor: _background,
        body: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 3),
              const Icon(Icons.savings_rounded, size: 78, color: _mint),
              const SizedBox(height: 20),
              const Text(
                'Budget Buddy',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Achieve more together',
                style: TextStyle(color: Color(0xFFD0E9E2), fontSize: 14),
              ),
              const Spacer(flex: 4),
              const Padding(
                padding: EdgeInsets.only(bottom: 32),
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: _mint,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() => _page = index),
                itemBuilder: (context, index) {
                  final item = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(28, 18, 28, 12),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            '${index + 1} / ${_pages.length}',
                            style: const TextStyle(
                              color: Color(0xFFB8DAD2),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 220,
                          height: 220,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF1C5750),
                            border: Border.all(
                              color: const Color(0xFF2C7466),
                              width: 1.5,
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 164,
                                height: 164,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: item.accent.withValues(alpha: .12),
                                ),
                              ),
                              Icon(item.icon, size: 104, color: item.accent),
                              Positioned(
                                right: 28,
                                top: 35,
                                child: Icon(
                                  Icons.auto_awesome_rounded,
                                  size: 25,
                                  color: _mint.withValues(alpha: .9),
                                ),
                              ),
                              Positioned(
                                left: 27,
                                bottom: 40,
                                child: Icon(
                                  Icons.circle,
                                  size: 14,
                                  color: item.accent.withValues(alpha: .7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(22, 27, 22, 26),
                          decoration: const BoxDecoration(
                            color: _panel,
                            borderRadius: BorderRadius.all(Radius.circular(26)),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  _pages.length,
                                  (dot) => AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                    width: dot == index ? 18 : 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: dot == index
                                          ? _mint
                                          : const Color(0xFF72AFA1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 25),
                              Text(
                                item.title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  height: 1.16,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -.4,
                                ),
                              ),
                              const SizedBox(height: 13),
                              Text(
                                item.description,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFFD0E9E2),
                                  fontSize: 13,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: _next,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _mint,
                                    foregroundColor: _background,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    index == _pages.length - 1
                                        ? 'Get Started'
                                        : 'Next',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IntroPageData {
  const _IntroPageData({
    required this.title,
    required this.description,
    required this.icon,
    required this.accent,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color accent;
}
