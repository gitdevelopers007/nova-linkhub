import 'dart:async';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  Offset mousePos = Offset.zero;
  bool isSignup = false;
  bool showPopup = true;

  final TextEditingController passwordCtrl = TextEditingController();

  late AnimationController anim;
  late Animation<double> scale;

  @override
  void initState() {
    super.initState();
    anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    scale = Tween(begin: 0.95, end: 1.0)
        .animate(CurvedAnimation(parent: anim, curve: Curves.easeOut));
    anim.forward();

    Timer(const Duration(seconds: 5), () {
      if (mounted) setState(() => showPopup = false);
    });
  }

  @override
  void dispose() {
    anim.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  // PASSWORD RULES
  bool minLen(String v) => v.length >= 8;
  bool upper(String v) => v.contains(RegExp(r'[A-Z]'));
  bool number(String v) => v.contains(RegExp(r'[0-9]'));
  bool special(String v) =>
      v.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  bool get validPassword {
    final v = passwordCtrl.text;
    return minLen(v) && upper(v) && number(v) && special(v);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: MouseRegion(
        onHover: (e) => setState(() => mousePos = e.position),
        child: Stack(
          children: [
            // Cursor glow
            Positioned(
              left: mousePos.dx - 180,
              top: mousePos.dy - 180,
              child: Container(
                width: 360,
                height: 360,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.green.withOpacity(0.18),
                      Colors.transparent
                    ],
                  ),
                ),
              ),
            ),

            // Login card
            Center(
              child: ScaleTransition(
                scale: scale,
                child: Container(
                  width: 380,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B0B0B),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.green.withOpacity(0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.35),
                        blurRadius: 30,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "NOVA",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "One link. Infinite presence.",
                        style:
                            TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      const SizedBox(height: 26),

                      _input("Email"),
                      const SizedBox(height: 14),

                      _input(
                        "Password",
                        obscure: true,
                        controller: passwordCtrl,
                        onChanged: (_) => setState(() {}),
                      ),

                      if (isSignup) ...[
                        const SizedBox(height: 12),
                        _rule("At least 8 characters", minLen(passwordCtrl.text)),
                        _rule("1 uppercase letter", upper(passwordCtrl.text)),
                        _rule("1 number", number(passwordCtrl.text)),
                        _rule(
                            "1 special character", special(passwordCtrl.text)),
                      ],

                      const SizedBox(height: 22),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: isSignup && !validPassword
                              ? null
                              : () {
                                  Navigator.pushReplacementNamed(
                                      context, '/dashboard');
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            isSignup ? "Create Account" : "Login",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      GestureDetector(
                        onTap: () => setState(() => isSignup = !isSignup),
                        child: Text(
                          isSignup
                              ? "Already have an account? Login"
                              : "Don’t have an account? Sign up",
                          style: const TextStyle(
                              color: Colors.green, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Popup
            if (showPopup)
              Positioned(
                right: 24,
                bottom: 24,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF101010),
                    borderRadius: BorderRadius.circular(14),
                    border:
                        Border.all(color: Colors.green.withOpacity(0.4)),
                  ),
                  child: const Text(
                    "🇮🇳 Happy 77th Republic Day!",
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _input(
    String hint, {
    bool obscure = false,
    TextEditingController? controller,
    void Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: const Color(0xFF111111),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: Colors.green, width: 1.2),
        ),
      ),
    );
  }

  Widget _rule(String text, bool ok) {
    return Row(
      children: [
        Icon(
          ok ? Icons.check_circle : Icons.circle_outlined,
          size: 14,
          color: ok ? Colors.green : Colors.white38,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: ok ? Colors.green : Colors.white38,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
