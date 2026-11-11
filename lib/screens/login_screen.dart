import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/brand.dart';

/// Analyze Pro login: the photograph fills the top, and a rounded white card
/// carries the branding and the coordinator's credentials.
class LoginScreen extends StatefulWidget {
  /// Called with the entered code and password. Returns an error message to
  /// show, or null on success. Injected so tests need no network.
  final Future<String?> Function(String code, String password)? onLogin;

  const LoginScreen({super.key, this.onLogin});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _code = TextEditingController();
  final _password = TextEditingController();

  bool _obscure = true;
  bool _busy = false;

  @override
  void dispose() {
    _code.dispose();
    _password.dispose();
    super.dispose();
  }

  void _snack(String message, {bool error = true}) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: error
              ? const Color(0xFFB3261E)
              : const Color(0xFF13A05B),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Future<void> _submit() async {
    final code = _code.text.trim();
    final password = _password.text;

    if (code.isEmpty) {
      _snack('Please enter your Coordinator Code.');
      return;
    }
    if (password.isEmpty) {
      _snack('Please enter your password.');
      return;
    }

    final onLogin = widget.onLogin;
    if (onLogin == null) {
      // No backend is wired yet; say so rather than pretend to sign in.
      _snack('Sign-in is not connected to the server yet.');
      return;
    }

    setState(() => _busy = true);
    final error = await onLogin(code, password);
    if (!mounted) return;
    setState(() => _busy = false);

    if (error != null) {
      _snack(error);
      return;
    }
    _snack('Signed in.', error: false);
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      // The card is sized to fit, so the layout must not be squeezed when the
      // keyboard opens; the fields stay visible above it.
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          // Photograph across the top, with the tagline over it. The design
          // gives it the first 43% of the screen.
          SizedBox(
            height: media.size.height * 0.43,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                const ColoredBox(color: AppColors.white),
                // The supplied photograph, drawn as it is: its own white
                // room background is what the design shows behind the family.
                Image.asset(
                  Brand.familyPhoto,
                  // The whole photograph is shown, nothing cropped away: it
                  // is scaled down to fit the band and sits against the card,
                  // and its own white background makes the spare room above
                  // it invisible.
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomCenter,
                  excludeFromSemantics: true,
                ),
                Positioned(
                  right: 24,
                  top: media.padding.top + 10,
                  child: const BrandTagline(fontSize: 15),
                ),
              ],
            ),
          ),
          // The card takes the rest of the screen and lays its contents out
          // to fit: no scrolling.
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                0,
                16,
                14 + media.padding.bottom,
              ),
              child: _card(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card() {
    return Container(
      padding: const EdgeInsets.fromLTRB(26, 20, 26, 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.white, AppColors.coolWhite, AppColors.softBlueBg],
          stops: [0.0, 0.55, 1.0],
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 22,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Sized to its natural height and scaled down only when the screen
          // is too short for it. Nothing scrolls, and nothing overflows.
          LayoutBuilder(
            builder: (context, box) => FittedBox(
              fit: BoxFit.scaleDown,
              child: SizedBox(
                width: box.maxWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      Brand.logoMark,
                      height: 50,
                      fit: BoxFit.contain,
                      semanticLabel: 'Analyze Pro',
                    ),
                    const SizedBox(height: 4),
                    const AnalyzeProWordmark(fontSize: 27),
                    const SizedBox(height: 3),
                    const Text(
                      Brand.subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.subtitle,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Login',
                      style: TextStyle(
                        color: AppColors.navy,
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _field(
                      controller: _code,
                      icon: Icons.person_outline,
                      hint: 'Coordinator Code',
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 13),
                    _field(
                      controller: _password,
                      icon: Icons.lock_outline,
                      hint: 'Password',
                      obscure: _obscure,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _submit(),
                      suffix: IconButton(
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.fieldIcon,
                          size: 21,
                        ),
                        tooltip: _obscure ? 'Show password' : 'Hide password',
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    const SizedBox(height: 15),
                    _loginButton(),
                    const SizedBox(height: 4),
                    TextButton(
                      onPressed: () =>
                          _snack('Password reset is not available yet.'),
                      style: TextButton.styleFrom(
                        minimumSize: const Size(0, 34),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: AppColors.linkBlue,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const TrustFooter(ruleWidth: 56),
                    const SizedBox(height: 2),
                  ],
                ),
              ),
            ),
          ),
          // The growth mark sits in the card's lower right corner, as in the
          // design.
          const Positioned(right: -4, bottom: -2, child: LeafMark(size: 46)),
        ],
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    bool obscure = false,
    Widget? suffix,
    TextInputAction? textInputAction,
    ValueChanged<String>? onSubmitted,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.fieldBorder),
        boxShadow: const [
          BoxShadow(
            color: AppColors.fieldShadow,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        textInputAction: textInputAction,
        onSubmitted: onSubmitted,
        style: const TextStyle(color: AppColors.navy, fontSize: 15.5),
        cursorColor: AppColors.brightBlue,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: AppColors.placeholder,
            fontSize: 15.5,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(icon, color: AppColors.fieldIcon, size: 22),
          suffixIcon: suffix,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 6,
          ),
        ),
      ),
    );
  }

  Widget _loginButton() {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.buttonTop,
            AppColors.buttonMid,
            AppColors.buttonBottom,
          ],
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.buttonShadow,
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: _busy ? null : _submit,
          child: SizedBox(
            height: 52,
            width: double.infinity,
            child: Center(
              child: _busy
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
