import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:my_widgets/my_widgets.dart';
import 'package:my_widgets/utils/pref.dart';
import 'package:my_widgets/utils/utils.dart';
import 'package:get/get.dart';
import 'package:my_widgets/widgets/btn.dart';
import 'package:my_widgets/widgets/dividers.dart';
import 'package:my_widgets/widgets/input.dart';
import 'package:my_widgets/widgets/txt.dart';

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
            child: ListView(
              children: [

                // Use Txt to show text with easy format options
                const Txt('I am Plane '),

                const Txt('I am Colored ', textColor: Clr.colorCyan,),


                const Txt('I am bold and Colored', hasBold: true,textColor: Clr.colorCyan,),

                const Txt('I am bold, Colored and UnderLine', hasBold: true,textColor: Clr.colorCyan,hasUnderLine: true,),

                const MyDivider(),
                const MyDivider(),

                TxtFormInput(
                  controller: inputEditingController,
                  hintText: 'I am with border,radius and with hint',
                  hasBorder: true,
                  radius: 20,
                  hasLabel: false,
                ),
                const MyDivider(),
                TxtFormInput(
                  controller: inputEditingController,
                  hintText: 'I am with border,radius, label and with hint',
                  hasBorder: true,
                  radius: 20,
                  labelText: 'I am label',
                ),
                const MyDivider(),
                TxtFormInput(
                  controller: inputEditingController,
                  hintText: 'I am with border,radius, label and with hint',
                  hasBorder: true,
                  radius: 20,
                  labelText: 'I am label',
                  hasLabelOnTop: false,
                ),
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

                const MyDivider(),
                Btn(text: 'I am button',onPressed: (){},bgColor: Clr.colorCyan,)

              ],
            ),
          ),
        ),
      ),
    );
  }
}
