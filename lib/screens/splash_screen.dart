import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';
import '../widgets/brand.dart';
import 'login_screen.dart';

/// The Analyze Pro splash: decorative curves, branding, the mother-and-child
/// photograph, and the trust footer. Hands over to the login screen.
class SplashScreen extends StatefulWidget {
  /// How long the splash is held before the login screen replaces it.
  final Duration hold;

  /// Set false in tests so the timer never fires.
  final bool autoAdvance;

  const SplashScreen({
    super.key,
    this.hold = const Duration(milliseconds: 2600),
    this.autoAdvance = true,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.autoAdvance) {
      _timer = Timer(widget.hold, _openLogin);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _openLogin() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (_, _, _) => const LoginScreen(),
        transitionsBuilder: (_, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // The curve artwork spans the whole screen: upper-left layers and
          // the lower waves live in one file.
          Positioned.fill(
            child: SvgPicture.asset(
              Brand.curves,
              fit: BoxFit.fill,
              excludeFromSemantics: true,
            ),
          ),
          const Positioned(left: 24, top: 58, child: _Dots()),
          const Positioned(right: 22, top: 44, child: BrandTagline()),
          SafeArea(child: _content(context)),
          const Positioned(right: 32, bottom: 24, child: LeafMark(size: 48)),
        ],
      ),
    );
  }

  Widget _content(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Column(
      children: [
        // Clear of the tagline block.
        SizedBox(height: height * 0.055),
        Image.asset(
          Brand.logoMark,
          height: height * 0.155,
          fit: BoxFit.contain,
          semanticLabel: 'Analyze Pro',
        ),
        const SizedBox(height: 12),
        const AnalyzeProWordmark(fontSize: 42),
        const SizedBox(height: 6),
        const Text(
          Brand.subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.subtitle,
            fontSize: 14.5,
            fontWeight: FontWeight.w400,
          ),
        ),
        // The photograph runs edge to edge and takes the middle of the
        // screen, as in the design; cover crops the sides rather than
        // leaving white bands.
        const SizedBox(height: 10),
        // The photograph runs edge to edge and takes the middle of the
        // screen, as in the design; cover crops the sides rather than
        // leaving white bands.
        // The photograph and the white band under it share whatever is left,
        // so a short screen shrinks both instead of overflowing.
        Expanded(
          flex: 8,
          child: SizedBox(
            width: double.infinity,
            child: Image.asset(
              Brand.familyPhoto,
              fit: BoxFit.cover,
              // Biased right so the tablet stays in frame when the sides
              // are cropped.
              alignment: const Alignment(0.28, 0),
              excludeFromSemantics: true,
            ),
          ),
        ),
        const Expanded(flex: 1, child: SizedBox.shrink()),
        const TrustFooter(),
        SizedBox(height: height * 0.055),
      ],
    );
  }
}

/// The two pale dots in the upper-left corner.
class _Dots extends StatelessWidget {
  const _Dots();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 56,
      height: 44,
      child: Stack(
        children: [
          Positioned(left: 16, top: 0, child: _Dot(18)),
          Positioned(left: 0, top: 22, child: _Dot(13)),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final double size;

  const _Dot(this.size);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFFB5D7FA),
        shape: BoxShape.circle,
      ),
    );
  }
}
