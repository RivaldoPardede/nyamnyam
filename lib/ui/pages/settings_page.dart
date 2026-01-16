import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/reminder_provider.dart';
import '../../providers/theme_provider.dart';
import '../../utils/app_colors.dart';

/// Modern Settings Page with Grouped sections
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Appearance Section
          _buildSectionTitle(theme, 'Appearance'),
          _buildSettingsContainer(
            theme,
            children: [
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, _) {
                  return Column(
                    children: [
                      ListTile(
                        leading: _buildIcon(
                            Icons.palette_rounded, Colors.purple, theme),
                        title: const Text('Theme Mode'),
                        subtitle: Text(
                          _getThemeName(themeProvider.themeMode),
                          style: TextStyle(color: theme.colorScheme.primary),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: SegmentedButton<ThemeMode>(
                          segments: const [
                            ButtonSegment(
                              value: ThemeMode.system,
                              label: Text('System'),
                              icon: Icon(Icons.settings_suggest),
                            ),
                            ButtonSegment(
                              value: ThemeMode.light,
                              label: Text('Light'),
                              icon: Icon(Icons.light_mode),
                            ),
                            ButtonSegment(
                              value: ThemeMode.dark,
                              label: Text('Dark'),
                              icon: Icon(Icons.dark_mode),
                            ),
                          ],
                          selected: {themeProvider.themeMode},
                          onSelectionChanged: (selection) {
                            themeProvider.setThemeMode(selection.first);
                          },
                          style: ButtonStyle(
                            visualDensity: VisualDensity.compact,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Notifications Section
          _buildSectionTitle(theme, 'Notifications'),
          _buildSettingsContainer(
            theme,
            children: [
              Consumer<ReminderProvider>(
                builder: (context, reminderProvider, _) {
                  return SwitchListTile(
                    secondary: _buildIcon(
                        Icons.notifications_active_rounded, Colors.orange, theme),
                    title: const Text('Daily Reminder'),
                    subtitle: const Text('Lunch alert at 11:00 AM'),
                    value: reminderProvider.isEnabled,
                    onChanged: (value) => reminderProvider.setReminder(value),
                    activeColor: AppColors.primary,
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // About Section
          _buildSectionTitle(theme, 'About'),
          _buildSettingsContainer(
            theme,
            children: [
              ListTile(
                leading: _buildIcon(Icons.info_rounded, Colors.blue, theme),
                title: const Text('App Version'),
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'v1.0.0',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const Divider(height: 1, indent: 56),
              ListTile(
                leading: _buildIcon(Icons.code_rounded, Colors.grey, theme),
                title: const Text('Developed by'),
                subtitle: const Text('New Model AI Assistant'),
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingsContainer(ThemeData theme,
      {required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildIcon(IconData icon, Color color, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  String _getThemeName(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.system => 'System Default',
      ThemeMode.light => 'Light Mode',
      ThemeMode.dark => 'Dark Mode',
    };
  }
}
