import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PaginationShimmer extends StatelessWidget {
  const PaginationShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 24,
          separatorBuilder: (_, __) => const SizedBox(width: 9.5),
          itemBuilder: (context, index) {
            return Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            );
          },
        ),
      ),
    );
  }
}