import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// A futuristic hexagon mesh background with ambient glows
class MeshBackground extends StatelessWidget {
  final Widget child;

  const MeshBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Deep Background Gradient
        Container(
          decoration: const BoxDecoration(
            gradient: AppColors.bgGradient,
          ),
        ),

        // 2. Ambient Glows (Top Left - Cyan)
        Positioned(
          top: -100,
          left: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.secondary.withAlpha(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondary.withAlpha(20),
                  blurRadius: 100,
                  spreadRadius: 50,
                ),
              ],
            ),
          ),
        ),

        // 3. Ambient Glows (Bottom Right - Orange)
        Positioned(
          bottom: -100,
          right: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withAlpha(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withAlpha(20),
                  blurRadius: 100,
                  spreadRadius: 50,
                ),
              ],
            ),
          ),
        ),

        // 4. Removed Hexagon CustomPainter for massive performance gain.
        // Ambient glows provide enough "Cyber" aesthetic without 60fps locking rasterization.
        
        // 5. The Actual Content
        child,
      ],
    );
  }
}
