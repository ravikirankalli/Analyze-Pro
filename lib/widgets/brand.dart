import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';

/// Asset paths, in one place so a renamed file breaks in one spot.
class Brand {
  Brand._();

  static const logoMark = 'assets/images/logo_mark.png';
  static const familyPhoto = 'assets/images/family.png';
  static const curves = 'assets/svg/curves_layers.svg';
  static const leaves = 'assets/svg/leaves.svg';

  static const title = 'Analyze Pro';
  static const subtitle = 'Student Progress Insights for Parents';
  static const trust = 'Andhra Educational Trust';
}

/// "Analyze Pro" in its two brand colours: navy, then bright blue.
class AnalyzeProWordmark extends StatelessWidget {
  final double fontSize;

  const AnalyzeProWordmark({super.key, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w900,
      letterSpacing: -0.5,
      height: 1.05,
    );

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: style,
        children: const [
          TextSpan(text: 'Analyze', style: TextStyle(color: AppColors.navy)),
          TextSpan(text: ' '),
          TextSpan(text: 'Pro', style: TextStyle(color: AppColors.brightBlue)),
        ],
      ),
    );
  }
}

/// The handwritten "A Brighter / Tomorrow / Together" tagline with its curved
/// underline, right aligned.
class BrandTagline extends StatelessWidget {
  final double fontSize;

  const BrandTagline({super.key, this.fontSize = 17});

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      color: AppColors.tagline,
      fontSize: fontSize,
      height: 1.18,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.w500,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('A Brighter', style: style),
        Text('Tomorrow', style: style),
        Text('Together', style: style),
        const SizedBox(height: 4),
        CustomPaint(
          size: Size(fontSize * 5.2, fontSize * 0.75),
          painter: _TaglineUnderline(),
        ),
      ],
    );
  }
}

/// The thin curved stroke under the tagline.
class _TaglineUnderline extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.tagline
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(0, size.height * 0.1)
      ..quadraticBezierTo(
        size.width * 0.55,
        size.height * 1.25,
        size.width,
        size.height * 0.15,
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// "From" between two rules, with the trust name under it.
class TrustFooter extends StatelessWidget {
  final double ruleWidth;

  const TrustFooter({super.key, this.ruleWidth = 72});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _rule(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                'From',
                style: TextStyle(
                  color: AppColors.fromText,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            _rule(),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          Brand.trust,
          style: TextStyle(
            color: AppColors.trustBlue,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _rule() => Container(width: ruleWidth, height: 1.6, color: AppColors.rule);
}

/// The two-leaf growth mark. The source SVG carries its own pale blue, so it
/// is drawn as-is rather than re-tinted.
class LeafMark extends StatelessWidget {
  final double size;

  const LeafMark({super.key, this.size = 46});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      Brand.leaves,
      width: size,
      height: size,
      // Decorative only: it carries no meaning a screen reader needs.
      excludeFromSemantics: true,
    );
  }
}
