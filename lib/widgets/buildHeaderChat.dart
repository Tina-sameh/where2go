import 'package:flutter/material.dart';

import '../constants/appColors.dart';

Widget buildHeaderChat() {
  return SafeArea(
    bottom: false,
    child: Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Text('🗺️', style: TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                ' نروح فين ؟',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.botText,
                ),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    ),
  );
}
