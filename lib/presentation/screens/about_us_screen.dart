import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              // Profile Photo Card
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.18),
                        blurRadius: 28,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/191347109.png',
                      width: 130,
                      height: 130,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 130,
                        height: 130,
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        child: const Icon(Icons.person_rounded, size: 64),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Developer Name & Title
              Text(
                'MohammadAmin Baranzehi',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Creator of TimeFlow',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 18),
              // Bio or Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Passionate developer creating tools to help optimize, organize, and simplify everyday life. TimeFlow is crafted with care to help individuals gain deep insights into how they spend their daily hours and build better habits.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              // Divider with label
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      'CONNECT WITH ME',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 20),
              // Social Links List
              _SocialCardLink(
                icon: FontAwesomeIcons.github,
                label: 'GitHub',
                value: 'amin-baranzehi',
                url: 'https://github.com/amin-baranzehi',
                brandColor: isDark ? Colors.white : const Color(0xFF181717),
              ),
              _SocialCardLink(
                icon: FontAwesomeIcons.instagram,
                label: 'Instagram',
                value: 'amin.baranzehi_',
                url: 'https://instagram.com/amin.baranzehi_',
                brandColor: const Color(0xFFE4405F),
              ),
              _SocialCardLink(
                icon: FontAwesomeIcons.telegram,
                label: 'Telegram',
                value: 'amin_baranzehi',
                url: 'https://t.me/amin_baranzehi',
                brandColor: const Color(0xFF229ED9),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialCardLink extends StatelessWidget {
  const _SocialCardLink({
    required this.icon,
    required this.label,
    required this.value,
    required this.url,
    required this.brandColor,
  });

  final FaIconData icon;
  final String label;
  final String value;
  final String url;
  final Color brandColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: brandColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: FaIcon(icon, color: brandColor, size: 20),
        ),
        title: Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        trailing: Icon(
          Icons.open_in_new_rounded,
          size: 18,
          color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
        ),
        onTap: () => _open(url),
      ),
    );
  }

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
