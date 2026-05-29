import 'package:flutter/material.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/constants/app_colors.dart';
import '../controller/home_controller.dart';
import 'widgets/back_btn_widget.dart';
import 'widgets/confetti_painter.dart';
import 'widgets/feature_card_widget.dart';
import 'widgets/gift_card_row_widget.dart';
import 'widgets/wallet_icon.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late final HomeController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = HomeController(vsync: this);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq     = MediaQuery.of(context);
    final size   = mq.size;
    final safeT  = mq.padding.top;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final walletNaturalCY = safeT + 32.0 + 50.0;
    final centerOffset    = (size.height * 0.50) - walletNaturalCY;

    return Scaffold(
      body: Stack(
        children: [
          _GradientBg(screenH: size.height),
          _buildConfetti(size),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 32),
                    _buildWallet(centerOffset),
                    const SizedBox(height: 18),
                    _buildLogo(isDark, centerOffset),
                    const SizedBox(height: 28),
                    ..._buildCards(),
                    const SizedBox(height: 18),
                    _buildCta(isDark),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: safeT + 8, left: 16,
            child: const BackBtnWidget(),
          ),
          Positioned(
            top: safeT + 4, right: 8,
            child: FadeTransition(
              opacity: _ctrl.gearOpacity,
              child: IconButton(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.settings),
                icon: Icon(
                  Icons.settings_outlined,
                  color: isDark ? AppColors.textGrey : const Color(0xFF888888),
                  size: 22,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfetti(Size size) {
    return Positioned.fill(
      child: IgnorePointer(
        child: ExcludeSemantics(
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: _ctrl.confettiCtrl,
              builder: (ctx, w) => CustomPaint(
                painter: _DualConfettiPainter(
                  t:           _ctrl.confettiCtrl.value,
                  durationSec: 3.5,
                  piecesLeft:  _ctrl.piecesLeft,
                  piecesRight: _ctrl.piecesRight,
                ),
                size: size,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWallet(double centerOffset) {
    return ExcludeSemantics(
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _ctrl.walletCtrl,
            _ctrl.walletMoveCtrl,
            _ctrl.walletDoneNotifier,
          ]),
          builder: (_, child) {
            final done   = _ctrl.walletDoneNotifier.value;
            final scale  = done ? 1.0 : _ctrl.walletScale.value;
            final tilt   = done ? 0.0 : _ctrl.walletTilt.value;
            final moveDy = (1.0 - _ctrl.walletMoveProgress.value) * centerOffset;
            return Transform.translate(
              offset: Offset(0, moveDy),
              child: Transform.rotate(
                angle: tilt,
                child: Transform.scale(scale: scale, child: child),
              ),
            );
          },
          child: const _WalletWithGlow(),
        ),
      ),
    );
  }

  Widget _buildLogo(bool isDark, double centerOffset) {
    return ValueListenableBuilder<bool>(
      valueListenable: _ctrl.logoVisible,
      builder: (_, visible, child) => Offstage(
        offstage: !visible,
        child: child,
      ),
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _ctrl.logoCtrl,
          _ctrl.walletMoveCtrl,
        ]),
        builder: (_, child) {
          final moveDy  = (1.0 - _ctrl.walletMoveProgress.value) * centerOffset;
          final slideDy = _ctrl.logoSlide.value.dy * 80;
          return Transform.translate(
            offset: Offset(0, moveDy + slideDy),
            child: child,
          );
        },
        child: Column(
          children: [
            FadeTransition(
              opacity: _ctrl.blinkitOpacity,
              child: Text(
                'blinkit',
                style: TextStyle(
                  color:         isDark ? AppColors.textWhite : const Color(0xFF1A1A1A),
                  fontSize:      20,
                  fontWeight:    FontWeight.w900,
                  letterSpacing: 3.0,
                ),
              ),
            ),
            const SizedBox(height: 2),
            AnimatedBuilder(
              animation: _ctrl.logoCtrl,
              builder: (ctx, w) {
                final colour = Color.lerp(
                  isDark ? const Color(0xFF2A2A2A) : const Color(0xFFCCCCCC),
                  isDark ? AppColors.textWhite     : const Color(0xFF1A1A1A),
                  _ctrl.moneyOpacity.value,
                )!;
                return Text(
                  'MONEY',
                  style: TextStyle(
                    color:         colour,
                    fontSize:      45,
                    fontWeight:    FontWeight.w900,
                    letterSpacing: 6,
                    height:        1.0,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCards() {
    return List.generate(3, (i) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: FadeTransition(
        opacity: _ctrl.cardOpacity[i],
        child: AnimatedBuilder(
          animation: _ctrl.cardCtrls[i],
          builder: (_, child) => Transform.translate(
            offset: Offset(0, _ctrl.cardOffset[i].value.dy * 80),
            child: child,
          ),
          child: FeatureCardWidget(feature: _ctrl.features[i]),
        ),
      ),
    ));
  }

  Widget _buildCta(bool isDark) {
    return FadeTransition(
      opacity: _ctrl.ctaOpacity,
      child: AnimatedBuilder(
        animation: _ctrl.ctaCtrl,
        builder: (_, child) => Transform.translate(
          offset: Offset(0, _ctrl.ctaOffset.value.dy * 80),
          child: child,
        ),
        child: Column(
          children: [
            _GradientButton(label: 'Add Money', onTap: () {}),
            const SizedBox(height: 10),
            GiftCardRowWidget(
              onTap: () => Navigator.pushNamed(context, AppRoutes.claimGiftCard),
            ),
            const SizedBox(height: 28),
            Text(
              'Enjoy seamless\none tap payments',
              textAlign: TextAlign.center,
              style: TextStyle(
                color:         isDark ? AppColors.watermark : const Color(0xFFE0E0E0),
                fontSize:      28,
                fontWeight:    FontWeight.w900,
                height:        1.2,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _GradientBg extends StatelessWidget {
  final double screenH;
  const _GradientBg({required this.screenH});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: isDark ? const Color(0xFF0D0D0D) : const Color(0xFFF5F5F0)),
        Positioned(
          top: 0, left: 0, right: 0,
          height: screenH * 0.22,
          child: _TopDotStrip(isDark: isDark),
        ),
      ],
    );
  }
}

class _TopDotStrip extends StatelessWidget {
  final bool isDark;
  const _TopDotStrip({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end:   Alignment.bottomCenter,
              colors: isDark
                  ? const [Color(0xFF1E1600), Color(0xFF131000), Color(0xFF0D0D0D)]
                  : const [Color(0xFFFFF8E1), Color(0xFFFFF3E0), Color(0xFFF5F5F0)],
              stops: const [0.0, 0.55, 1.0],
            ),
          ),
        ),
        CustomPaint(painter: _DotGridPainter(isDark: isDark)),
      ],
    );
  }
}

class _DotGridPainter extends CustomPainter {
  final bool isDark;
  const _DotGridPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    const spacing = 13.0;
    const dotW    = 4.2;
    const dotH    = 5.2;
    const radius  = Radius.circular(1.5);
    final dotColor = isDark ? const Color(0xFF3A2C00) : const Color(0xFFDDAA00);
    final paint    = Paint();
    for (double y = 8.0; y < size.height; y += spacing) {
      for (double x = 0.0; x < size.width; x += spacing) {
        final opacity = (1.0 - y / size.height).clamp(0.0, 1.0);
        if (opacity < 0.04) continue;
        paint.color = dotColor.withValues(alpha: opacity * 0.88);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset(x, y), width: dotW, height: dotH),
            radius,
          ),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_DotGridPainter old) => old.isDark != isDark;
}


class _WalletWithGlow extends StatelessWidget {
  const _WalletWithGlow();

  @override
  Widget build(BuildContext context) =>
      const SizedBox(width: 100, height: 100, child: WalletIcon(size: 96));
}


class _DualConfettiPainter extends CustomPainter {
  final double             t;
  final double             durationSec;
  final List<ConfettiPiece> piecesLeft;
  final List<ConfettiPiece> piecesRight;

  const _DualConfettiPainter({
    required this.t,
    required this.durationSec,
    required this.piecesLeft,
    required this.piecesRight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    ConfettiBurstPainter(
      t: t, durationSec: durationSec,
      pieces: piecesLeft,  originNx: 0.12, originNy: 0.52,
    ).paint(canvas, size);
    ConfettiBurstPainter(
      t: t, durationSec: durationSec,
      pieces: piecesRight, originNx: 0.88, originNy: 0.52,
    ).paint(canvas, size);
  }

  @override
  bool shouldRepaint(_DualConfettiPainter old) => old.t != t;
}


class _GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _GradientButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity, height: 54,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.green, AppColors.greenDark],
            begin:  Alignment.topLeft,
            end:    Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color:      AppColors.green.withValues(alpha: 0.32),
              blurRadius: 18,
              offset:     const Offset(0, 7),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color:         Colors.white,
              fontSize:      16,
              fontWeight:    FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}