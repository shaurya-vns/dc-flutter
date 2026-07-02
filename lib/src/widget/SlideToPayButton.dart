import 'package:flutter/material.dart';

class SlideToPayButton extends StatefulWidget {
  final VoidCallback onSuccess;
  final String amount;
  final int index;

  const SlideToPayButton({
    super.key,
    this.index = 1,
    required this.onSuccess,
    required this.amount,
  });

  @override
  State<SlideToPayButton> createState() => _SlideToPayButtonState();
}

class _SlideToPayButtonState extends State<SlideToPayButton> {
  double _dragPosition = 0;
  double _maxDrag = 120;
  bool _completed = false;

  double _buttonSize = 45;

  @override
  Widget build(BuildContext context) {
    _buttonSize = 45;
    return LayoutBuilder(
      builder: (context, constraints) {
        _maxDrag = constraints.maxWidth - _buttonSize - 12;

        // Progress: 0.0 -> 1.0
        final progress = (_dragPosition / _maxDrag).clamp(0.0, 1.0);

        // Background changes from Dark Blue -> Light Blue
        final backgroundColor =
            Color.lerp(
              const Color(0xFFEA645F), // Dark Blue
              const Color(0xFF90CAF9), // Light Blue
              progress,
            )!;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          height: 56,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              /// Text
              Center(
                child: Text(
                  _completed
                      ? "Order Processing..."
                      : widget.index == 1
                      ? 'Slide To Order | ${widget.amount}'
                      : "Slide To Subscription | ${widget.amount}",
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              AnimatedPositioned(
                duration: const Duration(milliseconds: 50),
                left: _dragPosition,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    if (_completed) return;

                    setState(() {
                      _dragPosition += details.delta.dx;

                      if (_dragPosition < 0) {
                        _dragPosition = 0;
                      }

                      if (_dragPosition > _maxDrag) {
                        _dragPosition = _maxDrag;
                      }
                    });
                  },
                  onHorizontalDragEnd: (details) {
                    if (_dragPosition >= _maxDrag * 0.85) {
                      setState(() {
                        _dragPosition = _maxDrag;
                        _completed = true;
                      });

                      widget.onSuccess();

                      Future.delayed(const Duration(seconds: 2), () {
                        if (!mounted) return;

                        setState(() {
                          _dragPosition = 0;
                          _completed = false;
                        });
                      });
                    } else {
                      setState(() {
                        _dragPosition = 0;
                      });
                    }
                  },
                  child: Container(
                    width: _buttonSize,
                    height: _buttonSize,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 8,
                          color: Colors.black12,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      _completed ? Icons.check : Icons.double_arrow_rounded,
                      color: const Color(0xFFEA645F),
                      size: 28,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
