import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:my_widgets/my_widgets.dart';
import 'package:my_widgets/utils/pref.dart';
import 'package:my_widgets/utils/utils.dart';
import 'package:get/get.dart';
import 'package:my_widgets/widgets/input.dart';

var isArabic = false.obs;

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Pref.getPref();
  isArabic.value = Pref.getPrefBoolean(Pref.option1);

  String stgBaseURL = 'https://xvz/api/'; // optional
  pSetSettings(
    primaryColor: Clr.colorPrimary,
    secondaryColor: Colors.white,
    defaultImage: 'assets/images/avatar.png',
    defImageIsAsset: true,
    baseUrlLive: stgBaseURL,
    baseUrlTest: stgBaseURL,
    isLive: false,
    defaultRadius: Siz.defaultRadius,
    defaultBtnHeight: Siz.defaultBtnHeight,
    txtInputHasBorder: true,
    txtInputHasLabel: true,
    txtInputHasLabelOnTop: true,
    txtInputHasLabelWithStar: false,
    txtInoutDefaultContentPadding: const EdgeInsets.symmetric(horizontal: 10),
    fontWeight: FontWeight.w600,
    defaultFontSize: Siz.body17,
    localization: isArabic()?'ar':'en',

  );
  runApp(const MyApp());

}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  var inputEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Example My Widgets'),
        ),
        body: Container(
          padding: const EdgeInsets.all(30),
          child: Form(
            child: Column(
              children: [
                TxtFormInput(
                  controller: inputEditingController,
                  hasBorder: true,
                  fillColor: Clr.colorCyan,
                  removeAllBorders: true,
                  preFix: IconButton(icon: const Icon(Icons.remove), onPressed: () {
                    debugPrint('I am clickable');
                  },),
                  postFix: const Icon(Icons.add),
                  radius: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
