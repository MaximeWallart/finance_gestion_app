import 'package:finance_gestion_app/style/app_colors.dart';
import 'package:finance_gestion_app/views/param_sub_views/type_list_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

import '../utils/navigation.dart';

class ParametersView extends StatefulWidget {
  const ParametersView({super.key, required this.user});

  final User user;

  @override
  State<ParametersView> createState() => _ParametersViewState();
}

class _ParametersViewState extends State<ParametersView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SettingsList(sections: [
        SettingsSection(
          title: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.width * 0.15),
              child: Column(
                children: [
                  CircleAvatar(
                      backgroundImage: NetworkImage(widget.user.photoURL!),
                      radius: MediaQuery.of(context).size.width * 0.1),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.user.displayName!,
                      style: TextStyle(
                          color: AppColors.textRegularBlack,
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width * 0.05),
                    ),
                  )
                ],
              ),
            ),
          ),
          tiles: const [],
        ),
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
        SettingsSection(title: const Text("Personnalisation"), tiles: [
          SettingsTile.navigation(
              leading: const Icon(Icons.palette_outlined),
              title: const Text("Coloris")),
          SettingsTile.navigation(
              leading: const Icon(Icons.grid_view_rounded),
              title: const Text("Grille d'information"))
        ]),
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
