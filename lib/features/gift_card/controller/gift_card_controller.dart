import 'package:flutter/material.dart';

class GiftCardController extends ChangeNotifier {
  final codeController = TextEditingController();
  bool   isLoading     = false;
  String errorMessage  = '';

  Future<void> claimGiftCard(BuildContext context) async {
    final code = codeController.text.trim();
    if (code.isEmpty) {
      errorMessage = 'Please enter a gift card code';
      notifyListeners();
      return;
    }
    errorMessage = '';
    isLoading    = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1500));

    isLoading = false;
    notifyListeners();

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            SizedBox(width: 8),
            Text('Gift card redeemed successfully!',
                style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: const Color(0xFF2CC257),
        behavior:        SnackBarBehavior.floating,
        margin:          const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
    codeController.clear();
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }
}