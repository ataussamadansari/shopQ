import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/location_controller.dart';

class LocationScreen extends GetView<LocationController> {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Visual Icon
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.location_on_rounded, size: 80, color: Color(0xFF6F82DC)),
                ),
              ),
              const SizedBox(height: 40),

              // 2. Text Content
              const Text(
                "Select your location",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "Enter your 6-digit pin code to see available services in your area.",
                style: TextStyle(fontSize: 15, color: Colors.grey[600]),
              ),
              const SizedBox(height: 30),

              // 3. PinCode Input Field
              TextField(
                controller: controller.pinCodeController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 4),
                decoration: InputDecoration(
                  hintText: "Enter Pin Code",
                  hintStyle: const TextStyle(letterSpacing: 0, fontWeight: FontWeight.normal, fontSize: 16),
                  counterText: "",
                  filled: true,
                  fillColor: isDark ? Colors.white10 : Colors.grey[100],
                  prefixIcon: const Icon(Icons.map_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const Spacer(),

              // 4. Continue Button
              Obx(() => ElevatedButton(
                onPressed: controller.isValid ? controller.onVerifyPinCode : null,
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor: const Color(0xFF6F82DC).withOpacity(0.4),
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 0,
                ),
                child: const Text(
                  "Submit Location",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              )),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}