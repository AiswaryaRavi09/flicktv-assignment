import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../controller/gift_card_controller.dart';

class ClaimGiftCardView extends StatefulWidget {
  const ClaimGiftCardView({super.key});

  @override
  State<ClaimGiftCardView> createState() => _ClaimGiftCardViewState();
}

class _ClaimGiftCardViewState extends State<ClaimGiftCardView> {
  late final GiftCardController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = GiftCardController();
    _ctrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Claim Gift Card',
          style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w600,
            color: theme.appBarTheme.foregroundColor,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded,
              color: theme.appBarTheme.foregroundColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _GiftCardVisual(),
            const SizedBox(height: 32),
            Text('Gift Card Code',
                style: TextStyle(
                  color:      isDark ? Colors.white : const Color(0xFF1A1A1A),
                  fontSize:   15, fontWeight: FontWeight.w600,
                )),
            const SizedBox(height: 6),
            Text('Enter the code found on the back of your gift card',
                style: TextStyle(
                  color:    isDark ? AppColors.textGrey : const Color(0xFF888888),
                  fontSize: 13, height: 1.4,
                )),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF141414) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: isDark ? const Color(0xFF242424) : const Color(0xFFE0E0E0)),
              ),
              child: TextField(
                controller:          _ctrl.codeController,
                style: TextStyle(
                  color:         isDark ? Colors.white : const Color(0xFF1A1A1A),
                  fontSize:      17, fontWeight: FontWeight.w600,
                  letterSpacing: 2.5, fontFamily: 'Poppins',
                ),
                textCapitalization: TextCapitalization.characters,
                maxLength:          16,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9a-z]')),
                ],
                onChanged: (_) {
                  if (_ctrl.errorMessage.isNotEmpty) {
                    setState(() => _ctrl.errorMessage = '');
                  }
                },
                decoration: InputDecoration(
                  hintText: 'XXXXXXXXXXXXXXXX',
                  hintStyle: TextStyle(
                    color:         isDark ? const Color(0xFF3A3A3A) : const Color(0xFFCCCCCC),
                    fontSize:      17, letterSpacing: 2.5,
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 14, right: 10),
                    child: Icon(Icons.card_giftcard_rounded,
                        color: AppColors.amber, size: 22),
                  ),
                  prefixIconConstraints: const BoxConstraints(minWidth: 0),
                  border:          InputBorder.none,
                  contentPadding:  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  counterText:     '',
                ),
              ),
            ),
            if (_ctrl.errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 4),
                child: Text(_ctrl.errorMessage,
                    style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
              ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: _ctrl.isLoading
                  ? null
                  : () => _ctrl.claimGiftCard(context),
              child: AnimatedOpacity(
                opacity:  _ctrl.isLoading ? 0.75 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  width: double.infinity, height: 54,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF8C00), Color(0xFFFF4400)],
                      begin:  Alignment.topLeft,
                      end:    Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color:      const Color(0xFFFF8C00).withValues(alpha: 0.35),
                        blurRadius: 18, offset: const Offset(0, 7),
                      ),
                    ],
                  ),
                  child: Center(
                    child: _ctrl.isLoading
                        ? const SizedBox(
                            width: 22, height: 22,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2.5))
                        : const Text(
                            'Claim Gift Card',
                            style: TextStyle(
                              color:         Colors.white,
                              fontSize:      16, fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color:        isDark ? const Color(0xFF141414) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: isDark ? const Color(0xFF242424) : const Color(0xFFE0E0E0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('How it works',
                      style: TextStyle(
                        color:      isDark ? Colors.white : const Color(0xFF1A1A1A),
                        fontSize:   14, fontWeight: FontWeight.w600,
                      )),
                  const SizedBox(height: 14),
                  _HowItWorksStep(step: '1', text: 'Enter the 16-digit gift card code above',        isDark: isDark),
                  _HowItWorksStep(step: '2', text: 'Tap "Claim Gift Card" to verify the code',       isDark: isDark),
                  _HowItWorksStep(step: '3', text: 'Amount is instantly credited to your wallet',    isDark: isDark, isLast: true),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded,
                    size:  14,
                    color: isDark ? AppColors.textGrey : const Color(0xFFAAAAAA)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Gift cards are non-refundable and cannot be exchanged for cash. Valid for Blinkit purchases only.',
                    style: TextStyle(
                      color:    isDark ? AppColors.textGrey : const Color(0xFFAAAAAA),
                      fontSize: 11, height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GiftCardVisual extends StatelessWidget {
  const _GiftCardVisual();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, height: 185,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF8C00), Color(0xFFFF3300)],
          begin:  Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color:      const Color(0xFFFF8C00).withValues(alpha: 0.42),
            blurRadius: 32, offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(right: -28, top: -28,
            child: Container(width: 130, height: 130,
              decoration: BoxDecoration(shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.07)))),
          Positioned(right: 28, bottom: -50,
            child: Container(width: 155, height: 155,
              decoration: BoxDecoration(shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05)))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
            child: Column(
              crossAxisAlignment:  CrossAxisAlignment.start,
              mainAxisAlignment:   MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('blinkit',
                        style: TextStyle(
                          color: Colors.white, fontSize: 13,
                          fontWeight: FontWeight.w400, letterSpacing: 2.5,
                        )),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color:        Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('GIFT CARD',
                          style: TextStyle(
                            color: Colors.white, fontSize: 10,
                            fontWeight: FontWeight.w700, letterSpacing: 1.5,
                          )),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color:        Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.card_giftcard_rounded,
                          color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('MONEY',
                            style: TextStyle(
                              color: Colors.white, fontSize: 26,
                              fontWeight: FontWeight.w900, letterSpacing: 5,
                              height: 1.0,
                            )),
                        Text('Blinkit Wallet',
                            style: TextStyle(
                              color:    Colors.white.withValues(alpha: 0.65),
                              fontSize: 11,
                            )),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HowItWorksStep extends StatelessWidget {
  final String step;
  final String text;
  final bool   isDark;
  final bool   isLast;

  const _HowItWorksStep({
    required this.step,
    required this.text,
    required this.isDark,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26, height: 26,
            decoration: BoxDecoration(
              color: AppColors.amber.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(step,
                  style: TextStyle(
                    color:      AppColors.amber,
                    fontSize:   11, fontWeight: FontWeight.w700,
                  )),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(text,
                  style: TextStyle(
                    color:    isDark ? AppColors.textGrey : const Color(0xFF888888),
                    fontSize: 13, height: 1.4,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}