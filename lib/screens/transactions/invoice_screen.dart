import 'package:flutter/material.dart';
import 'package:lakasir/widgets/layout.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  @override
  Widget build(BuildContext context) {
    return Layout(
      noAppBar: true,
      padding: 60,
      child: ListView(
        children: [
          const Center(
            child: Text(
              "Shop Name",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
          ),
          const Center(
            child: Text(
              "Lorem ipsum dolor sit amet",
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: DashedLine(
              width: 0.3 * MediaQuery.of(context).size.width,
              height: 2,
            ),
          )
        ],
      ),
    );
  }
}

class DashedLine extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  const DashedLine({
    super.key,
    required this.width,
    required this.height,
    this.color = Colors.black, // Change the color if needed
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: DashedLinePainter(color),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  final Color color;

  DashedLinePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.height
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0; // Adjust the width of each dash
    const dashSpace = 5.0; // Adjust the space between dashes

    double currentX = 0;

    while (currentX < size.width) {
      canvas.drawLine(
        Offset(currentX, size.height / 2),
        Offset(currentX + dashWidth, size.height / 2),
        paint,
      );
      currentX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
