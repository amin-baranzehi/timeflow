import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:timeflow/core/app/app_state.dart';
import 'package:timeflow/core/theme/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          _ProfileHeader(dailyGoalHours: appState.dailyGoalHours),
          const SizedBox(height: 14),
          _SectionCard(
            title: 'Preferences',
            children: [
              _SettingSwitch(
                icon: Icons.notifications_active_outlined,
                title: 'Smart reminders',
                subtitle: 'Nudge when focus or break time drifts.',
                value: appState.smartReminders,
                onChanged: context.read<AppState>().setSmartReminders,
              ),
              _SettingSwitch(
                icon: Icons.timer_off_outlined,
                title: 'Auto-stop long sessions',
                subtitle: 'Flag sessions that run past your work rhythm.',
                value: appState.autoStopLongSessions,
                onChanged: context.read<AppState>().setAutoStopLongSessions,
              ),
              _SettingSwitch(
                icon: Icons.view_agenda_outlined,
                title: 'Compact timeline',
                subtitle: 'Show denser activity rows.',
                value: appState.compactTimeline,
                onChanged: context.read<AppState>().setCompactTimeline,
              ),
            ],
          ),
          const SizedBox(height: 14),
          _SectionCard(
            title: 'Daily Goal',
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.flag_outlined,
                    color: AppColors.goldenYellow,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${appState.dailyGoalHours.toStringAsFixed(1)} hours',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              Slider(
                value: appState.dailyGoalHours,
                min: 1,
                max: 12,
                divisions: 22,
                label: '${appState.dailyGoalHours.toStringAsFixed(1)}h',
                onChanged: context.read<AppState>().setDailyGoalHours,
              ),
            ],
          ),
          const SizedBox(height: 14),
          _SectionCard(
            title: 'Appearance',
            children: [
              SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(
                    value: ThemeMode.dark,
                    label: Text('Dark'),
                    icon: Icon(Icons.dark_mode_outlined),
                  ),
                  ButtonSegment(
                    value: ThemeMode.light,
                    label: Text('Light'),
                    icon: Icon(Icons.light_mode_outlined),
                  ),
                ],
                selected: {appState.themeMode},
                onSelectionChanged: (value) {
                  context.read<AppState>().setThemeMode(value.first);
                },
              ),
            ],
          ),
          const SizedBox(height: 14),
          const _AboutUsCard(),
        ],
      ),
    );
  }
}

class _AboutUsCard extends StatelessWidget {
  const _AboutUsCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('About Us', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/191347109.png',
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MohammadAmin Baranzehi',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Creator of TimeFlow',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _SocialLink(
              icon: Icons.code_rounded,
              label: 'GitHub',
              value: 'amin-baranzehi',
              url: 'https://github.com/amin-baranzehi',
            ),
            _SocialLink(
              icon: Icons.camera_alt_outlined,
              label: 'Instagram',
              value: 'amin.baranzehi_',
              url: 'https://instagram.com/amin.baranzehi_',
            ),
            _SocialLink(
              icon: Icons.chat_outlined,
              label: 'WhatsApp',
              value: '+19293223359',
              url: 'https://wa.me/19293223359',
            ),
            _SocialLink(
              icon: Icons.send_outlined,
              label: 'Telegram',
              value: 'amin_baranzehi',
              url: 'https://t.me/amin_baranzehi',
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialLink extends StatelessWidget {
  const _SocialLink({
    required this.icon,
    required this.label,
    required this.value,
    required this.url,
  });

  final IconData icon;
  final String label;
  final String value;
  final String url;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.skyBlue),
      title: Text(label),
      subtitle: Text(value),
      trailing: const Icon(Icons.open_in_new_rounded, size: 18),
      onTap: () => _open(url),
    );
  }

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.dailyGoalHours});

  final double dailyGoalHours;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.skyBlue.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Padding(
                padding: EdgeInsets.all(14),
                child: Icon(
                  Icons.hourglass_top_rounded,
                  color: AppColors.skyBlue,
                  size: 34,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TimeFlow Workspace',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Daily target: ${dailyGoalHours.toStringAsFixed(1)}h',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _SettingSwitch extends StatelessWidget {
  const _SettingSwitch({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      secondary: Icon(icon, color: AppColors.skyBlue),
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }
}
