import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class IndicadorCardShimmer extends StatefulWidget {
  const IndicadorCardShimmer({super.key});

  @override
  State<IndicadorCardShimmer> createState() =>
      _IndicadorCardShimmerState();
}

class _IndicadorCardShimmerState
    extends State<IndicadorCardShimmer> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovering = true),
        onExit: (_) => setState(() => isHovering = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()
            ..translate(0.0, isHovering ? -10.0 : 0.0)
            ..scale(isHovering ? 1.02 : 1.0),
          width: 297,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(
                    isHovering ? 0.18 : 0.05),
                blurRadius: isHovering ? 24 : 8,
                offset:
                Offset(0, isHovering ? 16 : 3),
              ),
            ],
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            period: const Duration(milliseconds: 1200),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                /// Ícone fake
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.circular(6),
                  ),
                ),

                const SizedBox(height: 18),

                /// Valor fake
                Container(
                  width: 120,
                  height: 28,
                  color: Colors.white,
                ),

                const SizedBox(height: 8),

                /// Título fake
                Container(
                  width: 160,
                  height: 14,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}