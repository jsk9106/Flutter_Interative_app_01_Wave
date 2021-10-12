import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:interactive_app_01_wave/screens/main_page/main_page.dart';

class WaveWidget extends StatefulWidget {
  const WaveWidget({Key? key, required this.waveColor, required this.waveStrength}) : super(key: key);

  final Color waveColor;
  final double waveStrength;

  @override
  State<WaveWidget> createState() => _WaveWidgetState();
}

class _WaveWidgetState extends State<WaveWidget> with SingleTickerProviderStateMixin{
  late final AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {

    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));
    _animation = Tween<double>(begin: 0, end: 2 * math.pi).animate(_animationController);

    _animationController.addListener(() {
      setState(() {});
    });
    _animationController.repeat();

    super.initState();
  }

  @override
  void dispose() {

    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onVerticalDragUpdate: (details) => yOffset = details.delta.dy,
      child: ClipPath(
        clipper: WaveClipper(_animation.value, widget.waveStrength),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          color: widget.waveColor,
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path>{
  WaveClipper(this.animationValue, this.waveStrength);

  final double animationValue;
  final double waveStrength;

  @override
  Path getClip(Size size) {
    var p = Path();
    var points = <Offset>[];
    for(int x = 0; x < size.width; x++){
      points.add(Offset(x.toDouble(), WaveClipper.getTWithX(x, animationValue, waveStrength)));
    }

    p.moveTo(0, WaveClipper.getTWithX(0, animationValue, waveStrength));
    p.addPolygon(points, false);
    p.lineTo(size.width, size.height);
    p.lineTo(0, size.height);

    return p;
  }

  static const double waveHeight = 40;
  static double getTWithX(int x, double animationValue, double waveStrength){

    var y = ((math.sin(animationValue + x * waveStrength) + 1) / 2) * waveHeight; // 0 ~ 1
    return y;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
