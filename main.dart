import 'package:apz_flutter_components/components/appz_alert/alert_style_config.dart';
import 'package:apz_flutter_components/components/appz_badges/appz_badges_style_config.dart';
import 'package:apz_flutter_components/components/appz_checkbox/appz_checkbox_style_config.dart';
import 'package:apz_flutter_components/components/appz_modal_header/appz_modal_header_style_config.dart';
import 'package:apz_flutter_components/components/appz_text/appz_text_style_config.dart';
import 'package:apz_flutter_components/components/apz_button/button_style_config.dart';
import 'package:apz_flutter_components/components/appz_progress_bar/progress_bar_style_config.dart';
import 'package:apz_flutter_components/components/apz_list_content/apz_list_content_style_config.dart';
import 'package:flutter/material.dart';
import 'package:apz_flutter_components/components/appz_dropdown_field/dropdown_style_config.dart';
import 'package:apz_flutter_components/components/appz_input_field/appz_input_style_config.dart';
import 'package:apz_flutter_components/components/appz_category/appz_category_style_config.dart';
import 'example/appz_alert_example.dart';
import 'example/appz_badges_example.dart';
import 'example/appz_checkbox_example.dart';
import 'example/appz_footer_example.dart';
import 'example/appz_image_example.dart';
import 'example/appz_category_list_example.dart';
import 'example/appz_modal_header_example.dart';
import 'example/appz_category_example.dart';
import 'package:apz_flutter_components/components/appz_radio/radio_style_config.dart';
import 'package:apz_flutter_components/components/appz_toggle/toggle_style_config.dart';
import 'package:apz_flutter_components/components/apz_menu/apz_menu_style_config.dart';

import 'example/appz_toggle_example.dart';
import 'example/apz_list_content_example.dart';
import 'example/apz_menu_example.dart';

import 'example/apz_list_content_example.dart';

Future<void> main() async {
  // Ensure that widget binding is initialized before calling native code.
  WidgetsFlutterBinding.ensureInitialized();

  await AlertStyleConfig.instance.load();
  await DropdownStyleConfig.instance.load();
  await AppzStyleConfig.instance.load();
  await ProgressBarStyleConfig.instance.load();
  await ButtonStyleConfig.instance.load();
  await AppzCategoryStyleConfig.instance.load();
  await RadioStyleConfig.instance.load();
  await ToggleStyleConfig.instance.load();
  await AppzBadgesStyleConfig.instance.load();
  await AppzTextStyleConfig.instance.load();
  await ApzListContentStyleConfig.instance.load();
  await ApzMenuStyleConfig.instance.load();
  await AppzModalHeaderStyleConfig.instance.load();
  await AppzCheckboxStyleConfig.instance.load();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AppzInputField Demo V2',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: AppzToggleExample(),
      debugShowCheckedModeBanner: false, // Optional: to hide the debug banner
    );
  }
}
