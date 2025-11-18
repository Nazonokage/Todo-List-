import 'dart:math';
import 'package:flutter/material.dart';

class Particle {
  late Offset position;
  late Offset velocity;
  late double size;
  late Color color;
  final Random random = Random();

  Particle(double width, double height) {
    reset(width, height);
  }

  void reset(double width, double height) {
    position = Offset(
      random.nextDouble() * width,
      random.nextDouble() * height,
    );
    velocity = Offset(
      (random.nextDouble() - 0.5) * 2,
      (random.nextDouble() - 0.5) * 2,
    );
    size = random.nextDouble() * 5 + 5;
    // Base color with full opacity for maximum visibility
    color = Colors.accents[random.nextInt(Colors.accents.length)].withValues(
      alpha: 1.0,
    );
  }

  void update(double width, double height) {
    position += velocity;
    if (position.dx < 0 ||
        position.dx > width ||
        position.dy < 0 ||
        position.dy > height) {
      reset(width, height);
    }
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final bool isDarkMode;
  final Color primaryColor;

  ParticlePainter(this.particles, this.isDarkMode, this.primaryColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (var p in particles) {
      // Use theme primary color as accent for particles
      Color adjustedColor = primaryColor.withValues(alpha: p.color.a);
      paint.color = adjustedColor;
      canvas.drawCircle(p.position, p.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ParticleField extends StatefulWidget {
  final bool isDarkMode;
  final Color primaryColor;
  const ParticleField({
    super.key,
    required this.isDarkMode,
    required this.primaryColor,
  });

  @override
  State<ParticleField> createState() => _ParticleFieldState();
}

class _ParticleFieldState extends State<ParticleField>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;
  final int particleCount = 150;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final size = MediaQuery.of(context).size;
    _particles = List.generate(
      particleCount,
      (index) => Particle(size.width, size.height),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        for (var p in _particles) {
          p.update(size.width, size.height);
        }
        return CustomPaint(
          painter: ParticlePainter(
            _particles,
            widget.isDarkMode,
            widget.primaryColor,
          ),
          size: size,
        );
      },
    );
  }
}
