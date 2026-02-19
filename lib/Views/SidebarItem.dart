import 'package:flutter/material.dart';

class SidebarItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const SidebarItem({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  State<SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<SidebarItem> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: hover ? Colors.white.withOpacity(0.6) : Colors.transparent,
          ),
          child: Row(
            children: [
              /// INDICADOR LATERAL
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 4,
                height: 48,
                color: hover ? Colors.blue : Colors.transparent,
              ),

              Expanded(
                child: ListTile(
                  leading: Icon(
                    widget.icon,
                    color: hover ? Colors.blue : Colors.black87,
                  ),
                  title: Text(
                    widget.title,
                    style: TextStyle(
                      fontWeight:
                      hover ? FontWeight.bold : FontWeight.normal,
                      color: hover ? Colors.blue : Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
