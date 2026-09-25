import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

/// Hero illustration for Welcome Screen (Matches Figma Screenshot 1:
/// Big yellow question mark, boy face with purple hair, speech bubbles, confetti)
class WelcomeHeroIllustration extends StatelessWidget {
  final double size;

  const WelcomeHeroIllustration({super.key, this.size = 240});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background soft ambient glow
          Container(
            width: size * 0.85,
            height: size * 0.85,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFEF3C7).withValues(alpha: 0.5),
            ),
          ),

          // Big Golden Yellow Question Mark in background
          Positioned(
            top: size * 0.05,
            right: size * 0.22,
            child: Transform.rotate(
              angle: 0.1,
              child: Text(
                '?',
                style: TextStyle(
                  fontSize: size * 0.65,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFFFFB703),
                  height: 1,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      offset: const Offset(4, 6),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Floating Pink Question Mark on right
          Positioned(
            top: size * 0.28,
            right: size * 0.08,
            child: Transform.rotate(
              angle: 0.2,
              child: const Text(
                '?',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFFF4D6D),
                  height: 1,
                ),
              ),
            ),
          ),

          // Floating Green Question Mark on bottom right
          Positioned(
            bottom: size * 0.15,
            right: size * 0.12,
            child: Transform.rotate(
              angle: -0.15,
              child: const Text(
                '?',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF10B981),
                  height: 1,
                ),
              ),
            ),
          ),

          // Speech bubble on left
          Positioned(
            top: size * 0.18,
            left: size * 0.08,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B6B),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  SizedBox(
                    width: 24,
                    height: 5,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Color(0xFF68D391),
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  SizedBox(
                    width: 18,
                    height: 5,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Color(0xFF68D391),
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Yellow sphere on bottom left
          Positioned(
            bottom: size * 0.22,
            left: size * 0.12,
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0xFFFFEE99), Color(0xFFFFB703)],
                  center: Alignment(-0.3, -0.3),
                ),
              ),
            ),
          ),

          // Central Boy Face Avatar with Purple Hair (Figma character design)
          Positioned(
            bottom: size * 0.14,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                // Teal/Blue Shirt collar at the base
                Positioned(
                  bottom: -size * 0.05,
                  child: Container(
                    width: size * 0.32,
                    height: size * 0.16,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(size * 0.08),
                    ),
                  ),
                ),

                // Left Ear
                Positioned(
                  left: -size * 0.025,
                  top: size * 0.20,
                  child: Container(
                    width: size * 0.08,
                    height: size * 0.08,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFD1A4),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                // Right Ear
                Positioned(
                  right: -size * 0.025,
                  top: size * 0.20,
                  child: Container(
                    width: size * 0.08,
                    height: size * 0.08,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFD1A4),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                // Head Container
                Container(
                  width: size * 0.44,
                  height: size * 0.44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFFDFBA),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Purple Hair back / top volume
                      Positioned(
                        top: 0,
                        child: Container(
                          width: size * 0.44,
                          height: size * 0.22,
                          decoration: const BoxDecoration(
                            color: Color(0xFF7E22CE),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(100),
                            ),
                          ),
                        ),
                      ),

                      // Stylish purple hair bangs swooping down
                      Positioned(
                        top: size * 0.10,
                        left: size * 0.06,
                        child: Transform.rotate(
                          angle: -0.2,
                          child: Container(
                            width: size * 0.20,
                            height: size * 0.10,
                            decoration: BoxDecoration(
                              color: const Color(0xFF6B21A8),
                              borderRadius: BorderRadius.circular(size * 0.05),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: size * 0.08,
                        right: size * 0.06,
                        child: Transform.rotate(
                          angle: 0.25,
                          child: Container(
                            width: size * 0.18,
                            height: size * 0.09,
                            decoration: BoxDecoration(
                              color: const Color(0xFF7E22CE),
                              borderRadius: BorderRadius.circular(size * 0.05),
                            ),
                          ),
                        ),
                      ),

                      // Left Eye with cute highlight dot
                      Positioned(
                        top: size * 0.22,
                        left: size * 0.12,
                        child: Container(
                          width: 8,
                          height: 11,
                          decoration: const BoxDecoration(
                            color: Color(0xFF1E293B),
                            shape: BoxShape.circle,
                          ),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              margin: const EdgeInsets.only(top: 1, right: 1),
                              width: 3,
                              height: 3,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Right Eye with cute highlight dot
                      Positioned(
                        top: size * 0.22,
                        right: size * 0.12,
                        child: Container(
                          width: 8,
                          height: 11,
                          decoration: const BoxDecoration(
                            color: Color(0xFF1E293B),
                            shape: BoxShape.circle,
                          ),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              margin: const EdgeInsets.only(top: 1, right: 1),
                              width: 3,
                              height: 3,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Rosy Cheeks
                      Positioned(
                        top: size * 0.28,
                        left: size * 0.07,
                        child: Container(
                          width: 12,
                          height: 7,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF8A80)
                                .withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      Positioned(
                        top: size * 0.28,
                        right: size * 0.07,
                        child: Container(
                          width: 12,
                          height: 7,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF8A80)
                                .withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),

                      // Cheerful Smile
                      Positioned(
                        top: size * 0.29,
                        child: Container(
                          width: 14,
                          height: 8,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: Color(0xFF1E293B), width: 2.2),
                            ),
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Hero illustration for Quiz Configuration (Matches Figma Screenshot 3:
/// Settings gear card with switches and hand tapping)
class ConfigHeroIllustration extends StatelessWidget {
  final double size;

  const ConfigHeroIllustration({super.key, this.size = 180});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background card container
          Container(
            width: size * 0.75,
            height: size * 0.75,
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFBAE6FD), width: 2),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Top Switch (Toggled on)
                Container(
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF0284C7), width: 2),
                  ),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFECDD3),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Bottom Switch (Toggled off)
                Container(
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF0284C7), width: 2),
                  ),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFDA4AF),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Gear Badge on top left
          Positioned(
            top: 4,
            left: 12,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFDE68A), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.settings_rounded,
                color: Color(0xFFD97706),
                size: 32,
              ),
            ),
          ),

          // Hand pressing button overlay icon motif
          Positioned(
            bottom: 6,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.touch_app_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Hero illustration for High Score / Congratulations (Matches Figma Screenshot 6:
/// Party popper horn blowing colorful confetti)
class PartyPopperIllustration extends StatelessWidget {
  final double size;

  const PartyPopperIllustration({super.key, this.size = 200});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Confetti particles in air
          CustomPaint(
            size: Size(size, size),
            painter: _ConfettiPainter(),
          ),

          // Party Popper Cone
          Positioned(
            bottom: size * 0.08,
            child: Transform.rotate(
              angle: -math.pi / 12,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  // Horn Cone
                  CustomPaint(
                    size: Size(size * 0.48, size * 0.52),
                    painter: _PopperConePainter(),
                  ),
                  // Horn opening oval
                  Container(
                    width: size * 0.44,
                    height: size * 0.16,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF70A6),
                      borderRadius: BorderRadius.all(
                        Radius.elliptical(size * 0.44, size * 0.16),
                      ),
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PopperConePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFB3C6)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.15)
      ..lineTo(size.width, size.height * 0.15)
      ..lineTo(size.width * 0.58, size.height)
      ..lineTo(size.width * 0.42, size.height)
      ..close();

    canvas.drawPath(path, paint);

    // Diagonal White Stripes
    final stripePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    canvas.save();
    canvas.clipPath(path);
    canvas.drawLine(
      Offset(-10, size.height * 0.35),
      Offset(size.width + 10, size.height * 0.55),
      stripePaint,
    );
    canvas.drawLine(
      Offset(-10, size.height * 0.65),
      Offset(size.width + 10, size.height * 0.85),
      stripePaint,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ConfettiPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final colors = [
      const Color(0xFF38BDF8),
      const Color(0xFFFBBF24),
      const Color(0xFF34D399),
      const Color(0xFFF472B6),
      const Color(0xFFA78BFA),
    ];

    final pieces = [
      [size.width * 0.2, size.height * 0.2, 8.0, 16.0, 0.4, 0],
      [size.width * 0.8, size.height * 0.25, 7.0, 14.0, -0.6, 1],
      [size.width * 0.35, size.height * 0.12, 6.0, 12.0, 0.8, 2],
      [size.width * 0.65, size.height * 0.15, 8.0, 15.0, -0.3, 3],
      [size.width * 0.15, size.height * 0.4, 10.0, 8.0, 0.5, 4],
      [size.width * 0.85, size.height * 0.42, 6.0, 16.0, 0.7, 0],
      [size.width * 0.5, size.height * 0.08, 7.0, 14.0, 0.2, 1],
    ];

    for (final p in pieces) {
      final paint = Paint()
        ..color = colors[p[5].toInt()]
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(p[0].toDouble(), p[1].toDouble());
      canvas.rotate(p[4].toDouble());
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset.zero,
            width: p[2].toDouble(),
            height: p[3].toDouble(),
          ),
          const Radius.circular(3),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Hero illustration for Low Score / Keep Trying (Matches Figma Screenshot 7:
/// Settings/Retry motif encouraging further practice)
class KeepTryingIllustration extends StatelessWidget {
  final double size;

  const KeepTryingIllustration({super.key, this.size = 200});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background soft circle
          Container(
            width: size * 0.8,
            height: size * 0.8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFEF2F2),
              border: Border.all(color: const Color(0xFFFEE2E2), width: 2),
            ),
          ),

          // Central icon illustration container
          Container(
            width: size * 0.55,
            height: size * 0.55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.fitness_center_rounded,
                      size: 42,
                      color: Color(0xFFEF4444),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Practice',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Lightbulb badge
          Positioned(
            top: 18,
            right: 24,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFFEF08A),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lightbulb_outline_rounded,
                color: Color(0xFFCA8A04),
                size: 24,
              ),
            ),
          ),

          // Refresh/Retry badge
          Positioned(
            bottom: 18,
            left: 24,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFBAE6FD),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.refresh_rounded,
                color: Color(0xFF0284C7),
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
