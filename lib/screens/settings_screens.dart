import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../auth/auth_screen.dart';
import '../theme/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  bool _useSystemTheme = true;
  String _selectedTimeFormat = '12h';
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('darkMode') ?? false;
      _useSystemTheme = prefs.getBool('useSystemTheme') ?? true;
      _selectedTimeFormat = prefs.getString('timeFormat') ?? '12h';
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', _isDarkMode);
    await prefs.setBool('useSystemTheme', _useSystemTheme);
    await prefs.setString('timeFormat', _selectedTimeFormat);
    await prefs.setBool('notifications', _notificationsEnabled);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSection(
            'Theme',
            [
              SwitchListTile(
                title: const Text('Use System Theme'),
                subtitle: const Text('Automatically match system settings'),
                value: _useSystemTheme,
                onChanged: (value) {
                  setState(() => _useSystemTheme = value);
                  context.read<ThemeProvider>().updateTheme(
                    useSystemTheme: value,
                  );
                  _saveSettings();
                },
              ),
              if (!_useSystemTheme)
                SwitchListTile(
                  title: const Text('Dark Mode'),
                  subtitle: const Text('Use dark theme'),
                  value: _isDarkMode,
                  onChanged: (value) {
                    setState(() => _isDarkMode = value);
                    context.read<ThemeProvider>().updateTheme(
                      isDarkMode: value,
                    );
                    _saveSettings();
                  },
                ),
              ListTile(
                title: const Text('Theme Color'),
                subtitle: const Text('Choose app accent color'),
                trailing: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: context.watch<ThemeProvider>().primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
                onTap: () => _showColorPicker(context),
              ),
            ],
          ),
          _buildSection(
            'Preferences',
            [
              SwitchListTile(
                title: const Text('Notifications'),
                subtitle: const Text('Enable push notifications'),
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() => _notificationsEnabled = value);
                  _saveSettings();
                },
              ),
              ListTile(
                title: const Text('Time Format'),
                subtitle: Text('Use $_selectedTimeFormat format'),
                trailing: DropdownButton<String>(
                  value: _selectedTimeFormat,
                  items: const [
                    DropdownMenuItem(value: '12h', child: Text('12-hour')),
                    DropdownMenuItem(value: '24h', child: Text('24-hour')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedTimeFormat = value);
                      _saveSettings();
                    }
                  },
                ),
              ),
            ],
          ),
          _buildSection(
            'Account',
            [
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Logout'),
                textColor: Colors.red,
                onTap: () => _confirmLogout(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        ...children,
        const Divider(),
      ],
    );
  }

  void _showColorPicker(BuildContext context) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Theme Color'),
        content: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: colors.map((color) {
            return InkWell(
              onTap: () {
                context.read<ThemeProvider>().updateTheme(primaryColor: color);
                Navigator.pop(context);
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: context.read<ThemeProvider>().primaryColor == color
                        ? Colors.white
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const AuthScreen()),
              (route) => false,
        );
      }
    }
  }
}