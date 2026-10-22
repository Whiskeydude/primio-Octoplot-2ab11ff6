import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class FloatingHero extends StatefulWidget {
  final double size;
  const FloatingHero({super.key, required this.size});

  @override
  State<FloatingHero> createState() => _FloatingHeroState();
}

class _FloatingHeroState extends State<FloatingHero> with SingleTickerProviderStateMixin {
  late final AnimationController _float =
      AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);

  @override
  void dispose() {
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.disableAnimationsOf(context);
    final image = Image.asset(
      'assets/images/octo_mastermind.png',
      width: widget.size,
      height: widget.size,
      fit: BoxFit.contain,
      semanticLabel: 'The octopus mastermind',
    );
    if (reduce) return image;
    return AnimatedBuilder(
      animation: _float,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, Curves.easeInOut.transform(_float.value) * AppTheme.floatDistance * 2 - AppTheme.floatDistance),
        child: child,
      ),
      child: image,
    );
  }
}
