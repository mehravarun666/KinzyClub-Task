import 'package:flutter/material.dart';

class ExpandingCircleIndicator extends StatefulWidget {
  const ExpandingCircleIndicator({super.key});

  @override
  _ExpandingCircleIndicatorState createState() => _ExpandingCircleIndicatorState();
}

class _ExpandingCircleIndicatorState extends State<ExpandingCircleIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Center(
          child: SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              children: List.generate(5, (index) {
                double ringSize = _calculateRingSize(index, _animation.value);
                return _buildCircleRing(ringSize, index);
              }),
            ),
          ),
        );
      },
    );
  }

  double _calculateRingSize(int index, double animationValue) {
    // The size increases with animationValue and index to simulate ripple effect
    return 30 + (index * 20) + (animationValue * 100);
  }

  Widget _buildCircleRing(double size, int index) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: RingPainter(
              color: Colors.red.withOpacity(1 - (index * 0.2)),
              strokeWidth: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}

class RingPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  RingPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final double radius = size.width / 2;
    canvas.drawCircle(size.center(Offset.zero), radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
