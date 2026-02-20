import 'package:flutter/material.dart';
import 'package:proj_flutter/helprs/Cores.dart';

class IndicadorCardWidget extends StatefulWidget {
  final IconData icon;
  final int valor;
  final String titulo;

  const IndicadorCardWidget({
    super.key,
    required this.icon,
    required this.valor,
    required this.titulo,
  });

  @override
  State<IndicadorCardWidget> createState() => _IndicadorCardWidgetState();
}

class _IndicadorCardWidgetState extends State<IndicadorCardWidget> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    final Color corHover = Cores.verde_claro;
    final Color corNormalIcon = Cores.verde_escuro;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => isHovering = true),
        onExit: (_) => setState(() => isHovering = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,

          /// 🔥 efeito levantar
          transform: Matrix4.identity()
            ..translate(0.0, isHovering ? -10.0 : 0.0)
            ..scale(isHovering ? 1.02 : 1.0),

          width: 297,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey.shade100, // permanece igual
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(
                    isHovering ? 0.18 : 0.05),
                blurRadius: isHovering ? 24 : 8,
                offset: Offset(0, isHovering ? 16 : 3),
              ),
            ],
          ),

          /// CONTEÚDO
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ÍCONE
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  widget.icon,
                  key: ValueKey(isHovering),
                  size: 28,
                  color:
                  isHovering ? corHover : corNormalIcon,
                ),
              ),

              const SizedBox(height: 18),

              /// VALOR
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color:
                  isHovering ? corHover : Colors.black,
                ),
                child: Text(widget.valor.toString()),
              ),

              const SizedBox(height: 6),

              /// TÍTULO
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 14,
                  color: isHovering
                      ? corHover
                      : Colors.grey.shade600,
                ),
                child: Text(widget.titulo),
              ),
            ],
          ),
        ),
      ),
    );
  }
}