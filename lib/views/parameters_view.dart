import 'package:finance_gestion_app/views/param_sub_views/type_list_view.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

import '../utils/navigation.dart';

class ParametersView extends StatefulWidget {
  const ParametersView({super.key});

  @override
  State<ParametersView> createState() => _ParametersViewState();
}

class _ParametersViewState extends State<ParametersView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SettingsList(sections: [
        SettingsSection(
          title: const Text("App"),
          tiles: [
            SettingsTile.navigation(
              leading: const Icon(Icons.language),
              title: const Text("Langue"),
              value: const Text("Français"),
            ),
            SettingsTile.navigation(
              leading: const Icon(Icons.label_outline_rounded),
              title: const Text("Types de transactions"),
              onPressed: (context) {
                toNotificationsScreen(context);
              },
            )
          ],
        ),
        SettingsSection(title: const Text("Accessibilité"), tiles: [
          SettingsTile.switchTile(
              leading: const Icon(Icons.contrast),
              initialValue: false,
              onToggle: (context) {},
              title: const Text("Contraste élevé"))
        ])
      ]),
    );
  }

  void toNotificationsScreen(BuildContext context) {
    Navigation.navigateTo(
      context: context,
      screen: const TypeListView(),
      style: NavigationRouteStyle.material,
    );
  }
}
