import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/themes/app_colors.dart';
import '../controllers/location_controller.dart';

class LocationScreen extends GetView<LocationController> {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    _buildIllustration(),
                    const SizedBox(height: 36),
                    _buildHeading(),
                    const SizedBox(height: 28),
                    _buildPinField(context),
                    const SizedBox(height: 12),
                    _buildHint(),
                    const Spacer(),
                    const SizedBox(height: 24),
                    _buildButton(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return Center(child: _PulsingLocationIcon());
  }

  Widget _buildHeading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Where should we\ndeliver?',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A1A),
            height: 1.25,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Enter your 6-digit PIN code to check\ndelivery availability in your area.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade500,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildPinField(BuildContext context) {
    return Obx(() {
      final isValid = controller.isValid;
      final hasText = controller.pinCodeText.value.isNotEmpty;

      return Container(
        height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isValid
                ? AppColors.primary
                : hasText
                ? Colors.grey.shade300
                : Colors.grey.shade200,
            width: isValid ? 2.0 : 1.5,
          ),
          color: const Color(0xFFF7F7F7),
          boxShadow: isValid
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.location_on_rounded,
                key: ValueKey(isValid),
                color: isValid ? AppColors.primary : Colors.grey.shade400,
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            Container(width: 1, height: 24, color: Colors.grey.shade200),
            Expanded(
              child: TextField(
                controller: controller.pinCodeController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 10,
                  color: Color(0xFF1A1A1A),
                ),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: '------',
                  hintStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 10,
                    color: Colors.grey.shade300,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      );
    });
  }

  Widget _buildHint() {
    return Obx(() {
      final len = controller.pinCodeText.value.length;
      if (len == 0) {
        return Text(
          'e.g. 110001 for New Delhi',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
        );
      }
      if (len < 6) {
        return Text(
          '${6 - len} more digit${6 - len == 1 ? '' : 's'} needed',
          style: TextStyle(fontSize: 12, color: Colors.orange.shade400),
        );
      }
      return Row(
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: 14,
            color: Colors.green.shade500,
          ),
          const SizedBox(width: 4),
          Text(
            'Checking availability...',
            style: TextStyle(fontSize: 12, color: Colors.green.shade500),
          ),
        ],
      );
    });
  }

  Widget _buildButton() {
    return Obx(() {
      final isEnabled = controller.isValid && !controller.isLoading.value;
      return Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: isEnabled
              ? const LinearGradient(
                  colors: [AppColors.primary, Color(0xFF8B9BFF)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          color: isEnabled ? null : Colors.grey.shade200,
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: isEnabled ? controller.onVerifyPinCode : null,
            child: Center(
              child: controller.isLoading.value
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Confirm Location',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isEnabled
                                ? Colors.white
                                : Colors.grey.shade400,
                          ),
                        ),
                        if (isEnabled) ...[
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
                      ],
                    ),
            ),
          ),
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Pulsing location icon widget
// ─────────────────────────────────────────────────────────────────────────────
class _PulsingLocationIcon extends StatefulWidget {
  @override
  State<_PulsingLocationIcon> createState() => _PulsingLocationIconState();
}

class _PulsingLocationIconState extends State<_PulsingLocationIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _pulse = Tween<double>(
      begin: 0.92,
      end: 1.08,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer pulse ring
          AnimatedBuilder(
            animation: _pulse,
            builder: (_, __) => Transform.scale(
              scale: _pulse.value,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.06),
                ),
              ),
            ),
          ),
          // Middle ring
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.1),
            ),
          ),
          // Inner circle with icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.primary, Color(0xFF8B9BFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.location_on_rounded,
              color: Colors.white,
              size: 36,
            ),
          ),
        ],
      ),
    );
  }
}
