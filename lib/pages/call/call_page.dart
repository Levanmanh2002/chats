import 'package:chats/pages/call/call_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CallPage extends GetView<CallController> {
  const CallPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Background
            _buildBackground(),

            // Main content
            Column(
              children: [
                const SizedBox(height: 40),
                _buildUserInfo(),
                const Spacer(),
                _buildCallStatus(),
                const SizedBox(height: 40),
                _buildCallControls(),
                const SizedBox(height: 60),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade900,
            Colors.black,
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      children: [
        // Avatar
        CircleAvatar(
          radius: 60,
          backgroundImage: controller.parameter.avatar != null ? NetworkImage(controller.parameter.avatar!) : null,
          child: controller.parameter.avatar == null ? Icon(Icons.person, size: 60, color: Colors.white) : null,
        ),
        const SizedBox(height: 20),

        // Name
        Text(
          controller.parameter.name ?? 'Unknown',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCallStatus() {
    return Obx(() {
      if (controller.remoteUidValue.value.isEmpty) {
        return Column(
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              'calling'.tr,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        );
      } else {
        return Text(
          _formatDuration(controller.connectionDuration.value),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        );
      }
    });
  }

  Widget _buildCallControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Speaker button
          Obx(() => _buildControlButton(
                icon: controller.isSpeakerOn.value ? Icons.volume_up : Icons.volume_down,
                onPressed: controller.toggleSpeaker,
                isActive: controller.isSpeakerOn.value,
              )),

          // Mic button
          Obx(() => _buildControlButton(
                icon: controller.isMicMuted.value ? Icons.mic_off : Icons.mic,
                onPressed: controller.toggleMic,
                isActive: !controller.isMicMuted.value,
              )),

          // End call button
          _buildControlButton(
            icon: Icons.call_end,
            onPressed: controller.endCall,
            backgroundColor: Colors.red,
            size: 70,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    bool isActive = true,
    Color? backgroundColor,
    double size = 60,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor ?? (isActive ? Colors.white24 : Colors.white12),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: size * 0.4,
        ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
