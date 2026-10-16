import 'dart:math' as math;
import 'package:flutter/material.dart';

enum BubbleState { idle, thinking, brace, fired }

class BubbleFaceWidget extends StatefulWidget {
  final BubbleState state;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const BubbleFaceWidget({
    super.key,
    this.state = BubbleState.idle,
    this.onTap,
    this.onLongPress,
  });

  @override
  State<BubbleFaceWidget> createState() => _BubbleFaceWidgetState();
}

class _BubbleFaceWidgetState extends State<BubbleFaceWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    if (widget.state == BubbleState.thinking) {
      _rotationController.repeat();
    }
  }

  @override
  void didUpdateWidget(BubbleFaceWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state == BubbleState.thinking) {
      _rotationController.repeat();
    } else {
      _rotationController.stop();
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWorking = widget.state == BubbleState.thinking;

    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: SizedBox(
        width: 64,
        height: 64,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (isWorking)
              AnimatedBuilder(
                animation: _rotationController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotationController.value * 2 * math.pi,
                    child: Container(
                      width: 62,
                      height: 62,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 3,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                  );
                },
              ),
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _backgroundColor(widget.state),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: Center(
                child: _buildFaceExpression(widget.state),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _backgroundColor(BubbleState state) {
    switch (state) {
      case BubbleState.fired:
        return Colors.red.shade600;
      case BubbleState.brace:
        return Colors.amber.shade700;
      case BubbleState.thinking:
        return Colors.deepOrange.shade600;
      case BubbleState.idle:
      default:
        return const Color(0xFFD97757);
    }
  }

  Widget _buildFaceExpression(BubbleState state) {
    switch (state) {
      case BubbleState.thinking:
        return const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.psychology, color: Colors.white, size: 28),
          ],
        );
      case BubbleState.brace:
        return const Icon(Icons.shield, color: Colors.white, size: 28);
      case BubbleState.fired:
        return const Icon(Icons.local_fire_department, color: Colors.white, size: 28);
      case BubbleState.idle:
      default:
        return const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(radius: 3, backgroundColor: Colors.white),
            SizedBox(width: 8),
            CircleAvatar(radius: 3, backgroundColor: Colors.white),
          ],
        );
    }
  }
}
