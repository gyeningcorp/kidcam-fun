import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_fonts.dart';
import '../storage/local_storage_service.dart';
import '../storage/media_index_db.dart';
import 'parent_gate_service.dart';

/// Keys for persisted settings in flutter_secure_storage.
abstract final class _SettingsKeys {
  static const soundEnabled = 'setting_sound_enabled';
  static const saveToPhotos = 'setting_save_to_photos';
  static const sessionTimerMinutes = 'setting_session_timer';
}

/// Provider for app settings stored in secure storage.
final settingsProvider =
    ChangeNotifierProvider<SettingsNotifier>((_) => SettingsNotifier());

class SettingsNotifier extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();

  bool _soundEnabled = true;
  bool _saveToPhotos = false;
  int _sessionTimerMinutes = 0; // 0 = off

  bool get soundEnabled => _soundEnabled;
  bool get saveToPhotos => _saveToPhotos;
  int get sessionTimerMinutes => _sessionTimerMinutes;

  /// Load persisted settings from secure storage.
  Future<void> load() async {
    _soundEnabled =
        (await _storage.read(key: _SettingsKeys.soundEnabled)) != 'false';
    _saveToPhotos =
        (await _storage.read(key: _SettingsKeys.saveToPhotos)) == 'true';
    final timer = await _storage.read(key: _SettingsKeys.sessionTimerMinutes);
    _sessionTimerMinutes = int.tryParse(timer ?? '') ?? 0;
    notifyListeners();
  }

  Future<void> setSoundEnabled(bool value) async {
    _soundEnabled = value;
    await _storage.write(
      key: _SettingsKeys.soundEnabled,
      value: value.toString(),
    );
    notifyListeners();
  }

  Future<void> setSaveToPhotos(bool value) async {
    _saveToPhotos = value;
    await _storage.write(
      key: _SettingsKeys.saveToPhotos,
      value: value.toString(),
    );
    notifyListeners();
  }

  Future<void> setSessionTimer(int minutes) async {
    _sessionTimerMinutes = minutes;
    await _storage.write(
      key: _SettingsKeys.sessionTimerMinutes,
      value: minutes.toString(),
    );
    notifyListeners();
  }
}

/// Parent settings screen accessible only through the parent gate.
class ParentSettingsScreen extends ConsumerStatefulWidget {
  const ParentSettingsScreen({super.key});

  @override
  ConsumerState<ParentSettingsScreen> createState() =>
      _ParentSettingsScreenState();
}

class _ParentSettingsScreenState extends ConsumerState<ParentSettingsScreen> {
  @override
  void initState() {
    super.initState();
    // Load persisted settings
    Future.microtask(() => ref.read(settingsProvider).load());
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);

    return WillPopScope(
      onWillPop: () async {
        // Lock the parent gate when leaving settings
        ref.read(parentGateServiceProvider).lock();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () {
              ref.read(parentGateServiceProvider).lock();
              Navigator.of(context).pop();
            },
          ),
          title: const Text('Parent Settings'),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            // Sound Effects toggle
            _buildToggle(
              icon: Icons.volume_up_rounded,
              label: 'Sound Effects',
              value: settings.soundEnabled,
              onChanged: (val) => settings.setSoundEnabled(val),
            ),

            // Save to Photos toggle
            _buildToggle(
              icon: Icons.photo_library_rounded,
              label: 'Save to Photos',
              value: settings.saveToPhotos,
              onChanged: (val) => settings.setSaveToPhotos(val),
            ),

            // Session Timer
            ListTile(
              leading: const Icon(Icons.timer_rounded, color: AppColors.coral),
              title: Text(
                'Session Timer',
                style: TextStyle(
                  fontFamily: AppFonts.primary,
                  fontWeight: AppFonts.bold,
                ),
              ),
              trailing: DropdownButton<int>(
                value: settings.sessionTimerMinutes,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(value: 0, child: Text('Off')),
                  DropdownMenuItem(value: 10, child: Text('10 min')),
                  DropdownMenuItem(value: 15, child: Text('15 min')),
                  DropdownMenuItem(value: 20, child: Text('20 min')),
                  DropdownMenuItem(value: 30, child: Text('30 min')),
                ],
                onChanged: (val) {
                  if (val != null) settings.setSessionTimer(val);
                },
              ),
            ),

            const _SectionDivider(title: 'Privacy'),

            // How this app works
            ListTile(
              leading:
                  const Icon(Icons.menu_book_rounded, color: AppColors.skyBlue),
              title: Text(
                'How this app works',
                style: TextStyle(
                  fontFamily: AppFonts.primary,
                  fontWeight: AppFonts.bold,
                ),
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => Navigator.of(context).pushNamed('/privacy'),
            ),

            // Clear all photos
            ListTile(
              leading: const Icon(Icons.delete_forever_rounded,
                  color: AppColors.cooldownRed),
              title: Text(
                'Clear all saved photos',
                style: TextStyle(
                  fontFamily: AppFonts.primary,
                  fontWeight: AppFonts.bold,
                ),
              ),
              onTap: () => _showClearPhotosDialog(context),
            ),

            const _SectionDivider(title: 'Premium'),

            // Unlock More Filters (placeholder)
            ListTile(
              leading: const Icon(Icons.lock_open_rounded,
                  color: AppColors.sunshineYellow),
              title: Text(
                'Unlock More Filters',
                style: TextStyle(
                  fontFamily: AppFonts.primary,
                  fontWeight: AppFonts.bold,
                ),
              ),
              subtitle: Text(
                '\$2.99 one-time purchase',
                style: TextStyle(
                  fontFamily: AppFonts.primary,
                  fontSize: 13,
                  color: AppColors.textLight,
                ),
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Coming soon!')),
                );
              },
            ),

            // Restore Purchase
            ListTile(
              leading: const Icon(Icons.restore_rounded,
                  color: AppColors.mintGreen),
              title: Text(
                'Restore Purchase',
                style: TextStyle(
                  fontFamily: AppFonts.primary,
                  fontWeight: AppFonts.bold,
                ),
              ),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Coming soon!')),
                );
              },
            ),

            const _SectionDivider(title: 'About'),

            // Version
            ListTile(
              title: Text(
                'Version',
                style: TextStyle(
                  fontFamily: AppFonts.primary,
                  fontWeight: AppFonts.bold,
                ),
              ),
              trailing: Text(
                '1.0.0',
                style: TextStyle(
                  fontFamily: AppFonts.primary,
                  color: AppColors.textLight,
                ),
              ),
            ),

            // Privacy Policy
            ListTile(
              title: Text(
                'Privacy Policy',
                style: TextStyle(
                  fontFamily: AppFonts.primary,
                  fontWeight: AppFonts.bold,
                ),
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => Navigator.of(context).pushNamed('/privacy'),
            ),

            // Terms of Use
            ListTile(
              title: Text(
                'Terms of Use',
                style: TextStyle(
                  fontFamily: AppFonts.primary,
                  fontWeight: AppFonts.bold,
                ),
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggle({
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(icon, color: AppColors.coral),
      title: Text(
        label,
        style: TextStyle(
          fontFamily: AppFonts.primary,
          fontWeight: AppFonts.bold,
        ),
      ),
      value: value,
      activeColor: AppColors.mintGreen,
      onChanged: onChanged,
    );
  }

  void _showClearPhotosDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Clear All Photos?',
          style: TextStyle(
            fontFamily: AppFonts.primary,
            fontWeight: AppFonts.extraBold,
          ),
        ),
        content: Text(
          'This will permanently delete all photos saved in KidCam Fun. This cannot be undone.',
          style: TextStyle(fontFamily: AppFonts.primary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final storage = ref.read(localStorageProvider);
              final mediaDb = ref.read(mediaIndexDbProvider);
              await storage.clearAllPhotos();
              await mediaDb.deleteAll();
              if (ctx.mounted) Navigator.of(ctx).pop();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All photos cleared.')),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.cooldownRed),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  final String title;

  const _SectionDivider({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: AppFonts.primary,
          fontWeight: AppFonts.extraBold,
          fontSize: 13,
          color: AppColors.textLight,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
