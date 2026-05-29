import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final themeCtrl = AppThemeScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
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
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          _SectionLabel(label: 'Appearance', isDark: isDark),
          const SizedBox(height: 12),
          _SettingsTile(
            icon:     isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
            title:    'Dark Mode',
            subtitle: isDark ? 'Currently Dark' : 'Currently Light',
            isDark:   isDark,
            trailing: Switch(
              value:     isDark,
              onChanged: (v) => themeCtrl.setDark(v),
            ),
          ),
          const SizedBox(height: 16),
          _ThemePreviewRow(isDark: isDark),
          const SizedBox(height: 32),
          _SectionLabel(label: 'About', isDark: isDark),
          const SizedBox(height: 12),
          _SettingsTile(
            icon:    Icons.wallet_rounded,
            title:   'Blinkit Money',
            subtitle:'Version 1.0.0',
            isDark:  isDark,
          ),
          const SizedBox(height: 8),
          _SettingsTile(
            icon:     Icons.privacy_tip_outlined,
            title:    'Privacy Policy',
            subtitle: 'View our privacy policy',
            isDark:   isDark,
            trailing: Icon(Icons.chevron_right_rounded,
                color: isDark ? AppColors.textGrey : const Color(0xFFBBBBBB),
                size: 20),
          ),
          const SizedBox(height: 8),
          _SettingsTile(
            icon:     Icons.description_outlined,
            title:    'Terms of Service',
            subtitle: 'View our terms',
            isDark:   isDark,
            trailing: Icon(Icons.chevron_right_rounded,
                color: isDark ? AppColors.textGrey : const Color(0xFFBBBBBB),
                size: 20),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final bool   isDark;
  const _SectionLabel({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) => Text(
        label.toUpperCase(),
        style: const TextStyle(
          color: AppColors.green, fontSize: 11,
          fontWeight: FontWeight.w700, letterSpacing: 1.4,
        ),
      );
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String   title;
  final String   subtitle;
  final bool     isDark;
  final Widget?  trailing;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isDark,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:        isDark ? const Color(0xFF141414) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: isDark ? const Color(0xFF242424) : const Color(0xFFE0E0E0)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color:        AppColors.green.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.green, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                      color:      isDark ? Colors.white : const Color(0xFF1A1A1A),
                      fontSize:   14, fontWeight: FontWeight.w600,
                    )),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: TextStyle(
                      color:    isDark ? AppColors.textGrey : const Color(0xFF888888),
                      fontSize: 12,
                    )),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

class _ThemePreviewRow extends StatelessWidget {
  final bool isDark;
  const _ThemePreviewRow({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _ThemeCard(label: 'Dark',  selected: isDark,  cardBg: const Color(0xFF141414), textColor: Colors.white,             borderColor: const Color(0xFF242424), iconBg: const Color(0xFF0A0A0A))),
        const SizedBox(width: 12),
        Expanded(child: _ThemeCard(label: 'Light', selected: !isDark, cardBg: Colors.white,            textColor: const Color(0xFF1A1A1A), borderColor: const Color(0xFFE0E0E0), iconBg: const Color(0xFFF0F0F0))),
      ],
    );
  }
}

class _ThemeCard extends StatelessWidget {
  final String label;
  final bool   selected;
  final Color  cardBg;
  final Color  textColor;
  final Color  borderColor;
  final Color  iconBg;

  const _ThemeCard({
    required this.label,
    required this.selected,
    required this.cardBg,
    required this.textColor,
    required this.borderColor,
    required this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 90,
      decoration: BoxDecoration(
        color:        cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected ? AppColors.green : borderColor,
          width: selected ? 2 : 1,
        ),
        boxShadow: selected
            ? [BoxShadow(
                color:      AppColors.green.withValues(alpha: 0.2),
                blurRadius: 12, offset: const Offset(0, 4))]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 34, height: 34,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(
              label == 'Dark' ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              color: selected ? AppColors.green : borderColor,
              size: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color:      selected ? AppColors.green : textColor.withValues(alpha: 0.6),
              fontSize:   13,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}