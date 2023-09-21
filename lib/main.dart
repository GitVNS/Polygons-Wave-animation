import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Hexagons(),
    );
  }
}

class Hexagons extends StatefulWidget {
  const Hexagons({super.key});

  @override
  State<Hexagons> createState() => _HexagonsState();
}

class _HexagonsState extends State<Hexagons>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Stack(
              fit: StackFit.expand,
              children: List.generate(
                16, //total number of shapes
                (index) {
                  var anim = DelayTween(delay: index / 32, begin: 0.3, end: 0.7)
                      .animate(_controller)
                      .value;
                  return CustomPaint(
                    painter: HexagonPainter(
                      center: size.height * anim,
                      r: size.width * (index / 16),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class HexagonPainter extends CustomPainter {
  final double center;
  final double r;
  HexagonPainter({required this.center, required this.r});

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = center;
    final double radius = r / 2;

    final Paint paint = Paint()
      ..color = Colors.deepPurple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final path = Path();

    var sidesForShape = 10; //change this to convert hexagon, pentagon, etc.

    for (int i = 0; i < sidesForShape; i++) {
      final double angle = (360 / sidesForShape) * i * pi / 180.0;
      final double x = centerX + radius * cos(angle);
      final double y = centerY + radius * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(HexagonPainter oldDelegate) =>
      center != oldDelegate.center || r != oldDelegate.r;
}

class DelayTween extends Tween<double> {
  DelayTween({
    double? begin,
    double? end,
    required this.delay,
  }) : super(begin: begin, end: end);

  final double delay;

  @override
  double lerp(double t) {
    return super.lerp((sin((t - delay) * 2 * pi) + 1) / 2);
  }

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}
