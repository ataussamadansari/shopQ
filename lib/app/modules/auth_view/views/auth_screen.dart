import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopq/app/core/themes/app_colors.dart';
import '../controllers/auth_controller.dart';

final List<List<String>> columnImages = [
  // Column 0
  [
    "assets/images/img_1.png",
    "assets/images/img_2.png",
    "assets/images/img_3.png",
    "assets/images/img_4.png",
    "assets/images/img_5.png",
    "assets/images/img_6.png",
  ],

  // Column 1
  [
    "assets/images/img_6.png",
    "assets/images/img_7.png",
    "assets/images/img_8.png",
    "assets/images/img_9.png",
    "assets/images/img_10.png",
    "assets/images/img_11.png",
  ],

  // Column 2
  [
    "assets/images/img_11.png",
    "assets/images/img_12.png",
    "assets/images/img_1.png",
    "assets/images/img_2.png",
    "assets/images/img_3.png",
    "assets/images/img_4.png",
  ],
];

class AuthScreen extends GetView<AuthController> {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // 1. Sliding Background
          _buildBackground(context),

          // Place this inside your main Stack, after the background widget
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.6, 1.0],
                  colors: [
                    Colors.white.withOpacity(0.2),
                    Colors.white.withOpacity(0.3),
                    Colors.white.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),

          // 2. Content
          Column(
            children: [
              const Spacer(flex: 2), // Pushes content to bottom 25-30%

              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[900] : Colors.white,
                  /*borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),*/
                ),
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        controller.isOtpSent.value
                            ? "Enter OTP"
                            : "Login or Signup",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        controller.isOtpSent.value
                            ? "Enter the code sent to your mobile"
                            : "Enter your mobile number to proceed",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 20),

                      // Toggle between Phone and OTP fields
                      controller.isOtpSent.value
                          ? _otpField()
                          : _phoneField(),

                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: controller.isButtonEnabled
                            ? controller.onContinuePressed
                            : null,
                        style: ElevatedButton.styleFrom(
                          disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                          minimumSize: const Size(double.infinity, 55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Continue",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),

                      const SizedBox(height: 15),
                      const Center(
                        child: Text(
                          "By clicking, I accept the T&C and Privacy Policy",
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _phoneField() {
    return TextField(
      controller: controller.phoneController,
      keyboardType: TextInputType.phone,
      maxLength: 10, // Locks input at 10 digits
      decoration: InputDecoration(
        counterText: "",
        // Hides the counter label
        prefixText: "+91  ",
        hintText: "Enter Mobile Number",
        filled: true,
        // fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _otpField() {
    return TextField(
      controller: controller.otpController,
      keyboardType: TextInputType.number,
      maxLength: 6,
      // Locks input at 6 digits
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        letterSpacing: 8,
      ),
      decoration: InputDecoration(
        counterText: "",
        // Hides the counter label
        hintText: "000000",
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildBackground(BuildContext context) {
    return OverflowBox(
      maxHeight: double.infinity,
      child: Transform.rotate(
        angle: -0.25,
        child: Transform.scale(
          scale: 1.6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (columnIndex) {
              bool isUp = columnIndex % 2 == 0;

              return AnimatedBuilder(
                animation: controller.animationController,
                builder: (context, child) {
                  // Smooth infinite-like movement
                  double movement = controller.animationController.value * 100.0;
                  double offset = isUp ? -movement : movement;

                  return Transform.translate(
                    offset: Offset(0, offset),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        children: List.generate(6, (index) {
                          // Logic to pick a different image for every box
                          String imagePath = columnImages[columnIndex][index];

                          return Container(
                            width: 90,
                            height: 90,
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              // Light tint to match the grocery app style
                              color: Colors.blueAccent.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Image.asset(
                                  imagePath,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}
