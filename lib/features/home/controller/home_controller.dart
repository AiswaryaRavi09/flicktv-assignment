import 'package:flutter/material.dart';
import '../model/feature_model.dart';
import '../view/widgets/confetti_painter.dart';

class HomeController {
  final walletDoneNotifier = ValueNotifier<bool>(false);
  final logoVisible        = ValueNotifier<bool>(false);

  late final List<ConfettiPiece> piecesLeft;
  late final List<ConfettiPiece> piecesRight;

  late final AnimationController confettiCtrl;

  late final AnimationController walletCtrl;
  late final Animation<double>   walletScale;
  late final Animation<double>   walletTilt;

  late final AnimationController walletMoveCtrl;
  late final Animation<double>   walletMoveProgress;

  late final AnimationController logoCtrl;
  late final Animation<double>   blinkitOpacity;
  late final Animation<double>   moneyOpacity;
  late final Animation<Offset>   logoSlide;

  late final List<AnimationController> cardCtrls;
  late final List<Animation<double>>   cardOpacity;
  late final List<Animation<Offset>>   cardOffset;

  late final AnimationController ctaCtrl;
  late final Animation<double>   ctaOpacity;
  late final Animation<Offset>   ctaOffset;

  late final AnimationController gearCtrl;
  late final Animation<double>   gearOpacity;

  late final AnimationController floatCtrl;
  late final Animation<double>   floatY;
  late final Animation<double>   floatTilt;

  final features = const [
    FeatureModel(
      title:    'Single tap payments',
      subtitle: 'Enjoy seamless payments without the wait for OTPs',
      icon:     Icons.touch_app_outlined,
    ),
    FeatureModel(
      title:    'Zero failures',
      subtitle: 'Zero payment failures ensure you never miss an order',
      icon:     Icons.wifi_tethering_rounded,
    ),
    FeatureModel(
      title:    'Real-time refunds',
      subtitle: 'No need to wait for refunds. Blinkit Money refunds are instant!',
      icon:     Icons.currency_rupee_rounded,
    ),
  ];

  HomeController({required TickerProvider vsync}) {
    piecesLeft  = makeConfettiPieces(40, seed: 7,  nxOffset:  1.2);
    piecesRight = makeConfettiPieces(40, seed: 42, nxOffset: -1.2);
    _setupAnimations(vsync);
    _playSequence();
  }

  void _setupAnimations(TickerProvider vsync) {
    confettiCtrl = AnimationController(
        vsync: vsync, duration: const Duration(milliseconds: 3500));

    walletCtrl = AnimationController(
        vsync: vsync, duration: const Duration(milliseconds: 500));
    walletScale = TweenSequence([
      TweenSequenceItem(
          tween: Tween(begin: 0.0, end: 1.20)
              .chain(CurveTween(curve: Curves.easeOutBack)),
          weight: 60),
      TweenSequenceItem(
          tween: Tween(begin: 1.20, end: 1.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 40),
    ]).animate(walletCtrl);
    walletTilt = TweenSequence([
      TweenSequenceItem(
          tween: Tween(begin: -0.38, end: 0.24)
              .chain(CurveTween(curve: Curves.easeOutBack)),
          weight: 55),
      TweenSequenceItem(
          tween: Tween(begin: 0.24, end: 0.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 45),
    ]).animate(walletCtrl);

    walletMoveCtrl    = AnimationController(
        vsync: vsync, duration: const Duration(milliseconds: 1000));
    walletMoveProgress = walletMoveCtrl;

    logoCtrl       = AnimationController(
        vsync: vsync, duration: const Duration(milliseconds: 600));
    blinkitOpacity = CurvedAnimation(
        parent: logoCtrl,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOut));
    moneyOpacity   = CurvedAnimation(
        parent: logoCtrl,
        curve: const Interval(0.28, 1.0, curve: Curves.easeOut));
    logoSlide = Tween(begin: const Offset(0, 0.22), end: Offset.zero)
        .animate(CurvedAnimation(parent: logoCtrl, curve: Curves.easeOutCubic));

    cardCtrls = List.generate(3, (_) => AnimationController(
        vsync: vsync, duration: const Duration(milliseconds: 750)));
    cardOpacity = cardCtrls
        .map((c) => CurvedAnimation(parent: c, curve: Curves.easeOut)
            as Animation<double>)
        .toList();
    cardOffset = cardCtrls
        .map((c) => Tween(begin: const Offset(0, 0.45), end: Offset.zero)
            .animate(CurvedAnimation(parent: c, curve: Curves.easeOutCubic)))
        .toList();

    ctaCtrl    = AnimationController(
        vsync: vsync, duration: const Duration(milliseconds: 750));
    ctaOpacity = CurvedAnimation(parent: ctaCtrl, curve: Curves.easeOut);
    ctaOffset  = Tween(begin: const Offset(0, 0.4), end: Offset.zero)
        .animate(CurvedAnimation(parent: ctaCtrl, curve: Curves.easeOutCubic));

    gearCtrl    = AnimationController(
        vsync: vsync, duration: const Duration(milliseconds: 320));
    gearOpacity = CurvedAnimation(parent: gearCtrl, curve: Curves.easeOut);

    floatCtrl = AnimationController(
        vsync: vsync, duration: const Duration(milliseconds: 2200));
    floatY    = Tween(begin: -10.0, end: 10.0)
        .animate(CurvedAnimation(parent: floatCtrl, curve: Curves.easeInOut));
    floatTilt = Tween(begin: -0.09, end: 0.09)
        .animate(CurvedAnimation(parent: floatCtrl, curve: Curves.easeInOut));
  }

  Future<void> _playSequence() async {
    await walletCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 800));

    confettiCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 800));

    await walletMoveCtrl.animateTo(
      0.28,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
    );

    logoVisible.value = true;
    await logoCtrl.forward();

    await walletMoveCtrl.animateTo(
      1.0,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
    );
    walletDoneNotifier.value = true;

    for (int i = 0; i < 3; i++) {
      await Future.delayed(const Duration(milliseconds: 360));
      cardCtrls[i].forward();
    }

    await Future.delayed(const Duration(milliseconds: 460));
    ctaCtrl.forward();
    gearCtrl.forward();
  }

  void dispose() {
    walletDoneNotifier.dispose();
    logoVisible.dispose();
    confettiCtrl.dispose();
    walletCtrl.dispose();
    walletMoveCtrl.dispose();
    logoCtrl.dispose();
    for (final c in cardCtrls) { c.dispose(); }
    ctaCtrl.dispose();
    gearCtrl.dispose();
    floatCtrl.dispose();
  }
}