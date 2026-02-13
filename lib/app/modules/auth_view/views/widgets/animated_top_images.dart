import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';

class AnimatedTopImages extends GetView<AuthController> {
  const AnimatedTopImages({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: controller.animationController,
        builder: (context, _) {
          return Transform.translate(
            offset: Offset(
              controller.animationController.value * 40,
              controller.animationController.value * 40,
            ),
            child: Transform.rotate(
              angle: -0.25, // 🔥 diagonal tilt
              child: ShaderMask(
                shaderCallback: (rect) {
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.white,
                      Colors.white,
                      Colors.transparent,
                    ],
                    stops: [0.0, 0.2, 0.8, 1.0],
                  ).createShader(rect);
                },
                blendMode: BlendMode.dstIn,
                child: _grid(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _grid() {
    return GridView.builder(
      padding: const EdgeInsets.all(40),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 24,
        crossAxisSpacing: 24,
        childAspectRatio: 1,
      ),
      itemCount: 18,
      itemBuilder: (_, index) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF1F3FF),
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(
              image: AssetImage("assets/images/image_1.jpg"),
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }
}

