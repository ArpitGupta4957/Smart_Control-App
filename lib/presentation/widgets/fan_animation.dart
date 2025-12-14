import 'dart:math';
import 'package:flutter/material.dart';

class FanAnimation extends StatefulWidget {
  final bool isSpinning;
  final int speed;
  
  const FanAnimation({
    super.key,
    required this.isSpinning,
    this.speed = 1,
  });

  @override
  State<FanAnimation> createState() => _FanAnimationState();
}

class _FanAnimationState extends State<FanAnimation> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _getRotationDuration(),
    );
    
    if (widget.isSpinning) {
      _controller.repeat();
    }
  }
  
  @override
  void didUpdateWidget(FanAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isSpinning != oldWidget.isSpinning || 
        widget.speed != oldWidget.speed) {
      _controller.duration = _getRotationDuration();
      
      if (widget.isSpinning) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }
  
  Duration _getRotationDuration() {
    // Faster rotation for higher speeds
    final baseMs = 2000;
    final speedFactor = 6 - widget.speed;
    return Duration(milliseconds: (baseMs * speedFactor / 5).round());
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: _controller.value * 2 * pi,
            child: child,
          );
        },
        child: CustomPaint(
          size: const Size(200, 200),
          painter: FanBladePainter(
            color: widget.isSpinning 
                ? Theme.of(context).colorScheme.primary
                : Colors.grey,
          ),
        ),
      ),
    );
  }
}

class FanBladePainter extends CustomPainter {
  final Color color;
  
  FanBladePainter({required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    final center = Offset(size.width / 2, size.height / 2);
    final bladeLength = size.width * 0.4;
    final bladeWidth = size.width * 0.15;
    
    // Draw 5 blades
    for (int i = 0; i < 5; i++) {
      final angle = (i * 2 * pi / 5);
      
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(angle);
      
      final path = Path();
      path.moveTo(0, 0);
      path.quadraticBezierTo(
        bladeLength * 0.5, -bladeWidth / 2,
        bladeLength, -bladeWidth / 4,
      );
      path.lineTo(bladeLength, bladeWidth / 4);
      path.quadraticBezierTo(
        bladeLength * 0.5, bladeWidth / 2,
        0, 0,
      );
      path.close();
      
      canvas.drawPath(path, paint);
      canvas.restore();
    }
    
    // Draw center circle
    canvas.drawCircle(
      center,
      size.width * 0.1,
      Paint()..color = color,
    );
  }
  
  @override
  bool shouldRepaint(FanBladePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}