import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PinCodeHelper {

  static void showPinCodeDialog() {
    final TextEditingController pinController = TextEditingController();
    final RxBool isValid = false.obs;

    pinController.addListener(() {
      isValid.value = pinController.text.length == 6;
    });

    Get.dialog(
      Obx(() => CupertinoAlertDialog(
        title: const Text("Enter Pincode"),
        content: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text("Enter your 6-digit delivery pincode to proceed."),
            ),
            const SizedBox(height: 10),
            CupertinoTextField(
              controller: pinController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              placeholder: "000000",
              textAlign: TextAlign.center,
              style: const TextStyle(letterSpacing: 8, fontWeight: FontWeight.bold),
              decoration: BoxDecoration(
                color: Get.isDarkMode ? CupertinoColors.systemGrey6 : CupertinoColors.extraLightBackgroundGray,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            // Only enable logic if valid
            onPressed: isValid.value
                ? () {
              print("Pincode Submitted: ${pinController.text}");
              Get.back();
              // Add your navigation or API logic here
            }
                : null,
            child: Text(
              "Submit",
              style: TextStyle(
                color: isValid.value ? CupertinoColors.activeBlue : CupertinoColors.inactiveGray,
              ),
            ),
          ),
        ],
      )),
      barrierDismissible: false, // User must interact with dialog
    );
  }


  static void showPinCodeSheet() {
    final TextEditingController pinController = TextEditingController();
    final RxBool isValid = false.obs;

    pinController.addListener(() {
      isValid.value = pinController.text.length == 6;
    });

    Get.bottomSheet(
      isScrollControlled: true,
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.grey[900] : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const Text(
              "Delivery Location",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text("Enter your pincode to check serviceability"),
            const SizedBox(height: 20),

            TextField(
              controller: pinController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              autofocus: true, // Pop keyboard immediately
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 8),
              decoration: InputDecoration(
                hintText: "000000",
                hintStyle: const TextStyle(letterSpacing: 0, fontWeight: FontWeight.normal),
                counterText: "",
                filled: true,
                fillColor: Get.isDarkMode ? Colors.white10 : Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            Obx(() => ElevatedButton(
              onPressed: isValid.value
                  ? () {
                Get.back(); // Close sheet
                print("Selected Pincode: ${pinController.text}");
                // Call your API or update global location state here
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6F82DC),
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 0,
              ),
              child: const Text("Submit", style: TextStyle(color: Colors.white, fontSize: 18)),
            )),
            // Space for keyboard
            SizedBox(height: MediaQuery.of(Get.context!).viewInsets.bottom),
          ],
        ),
      ),
    );
  }
}
