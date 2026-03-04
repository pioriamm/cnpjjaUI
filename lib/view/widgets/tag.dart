import 'package:flutter/material.dart';

class Tag extends StatefulWidget {
  final Widget child;
  final VoidCallback? chamar;
  final Color? cor;

  const Tag({super.key, required this.child, this.chamar, this.cor});

  @override
  State<Tag> createState() => _TagState();
}

class _TagState extends State<Tag> {
  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: widget.cor ?? Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
      child: widget.child,
    );

    if (widget.chamar == null) {
      return content;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: widget.chamar,
      child: content,
    );
  }
}
