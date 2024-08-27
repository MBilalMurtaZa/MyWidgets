import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_widgets/dialogs/dialogs.dart';
import 'package:my_widgets/my_widgets.dart';
import 'package:my_widgets/utils/dates.dart';
import 'package:my_widgets/utils/pref.dart';
import 'package:my_widgets/utils/utils.dart';
import 'package:my_widgets/widgets/btn.dart';
import 'package:my_widgets/widgets/dividers.dart';
import 'package:my_widgets/widgets/google_maps_helper.dart';
import 'package:my_widgets/widgets/input.dart';
import 'package:my_widgets/widgets/searchable_dropdown.dart';
import 'package:my_widgets/widgets/txt.dart';
import 'package:get/get.dart';

import 'main_web.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Pref.getPref();

  String stgBaseURL = 'https://xvz/api/'; // optional
  await pSetSettings(
      primaryColor: Colors.blueAccent,
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
      localization: 'ar',
    onHttpCallError: callHttpError
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
  List<SearchListModel> listDropdown = [
    SearchListModel(name: 'One', id: 1),
    SearchListModel(name: 'Two', id: 2),
    SearchListModel(name: 'Three', id: 3),
    SearchListModel(name: 'Four', id: 4),
  ];

  var searchAbleDropDownTap = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Example My Widgets'),
        ),
        
        body:  buildMainPage(),//buildMainPage(),
      ),
    );
  }

  Container buildMainPage() {
    return Container(
        padding: const EdgeInsets.all(30),
        child: Form(
          child: ListView(
            children: [
              Container(
                decoration: pBoxDecoration(
                    color: Clr.colorGreen, shape: BoxShape.circle),
                height: 100,
                width: 100,
              ),

              // Use Txt to show text with easy format options

              Txt(Dates.pDateToString(DateTime.now())),

              // Txt(Dates.pDateToString(DateTime.now(), localization: 'en')),

              // Use Txt to show text with easy format options
              const Txt('I am Plane '),

              TxtFormInput(
                onTap: ()=> {
                  pShowToast(message: 'OnTap called'),
                },
                controller: TextEditingController(text: "New text added"),
                borderWidth: 1,
                hintText: 'ie. your community',
                labelText: 'Location',
                borderRadius: BorderRadius.circular(12),
                labelStyle: TextStyle(color: Clr.colorPrimary,fontWeight: FontWeight.w500,fontSize: 14),
                labelPadding: 10,
                readOnly: true,

              ),

              const Txt(
                'I am Colored ',
                textColor: Clr.colorCyan,
              ),

              const Txt(
                'I am bold and Colored',
                hasBold: true,
                textColor: Clr.colorCyan,
              ),

              const Txt(
                'I am bold, Colored and UnderLine',
                hasBold: true,
                textColor: Clr.colorCyan,
                hasUnderLine: true,
              ),

              const MyDivider(),
              const MyDivider(),
              Form(
                key: formKey,
                child: TxtFormInput(
                  controller: inputEditingController,
                  hintText: 'I am with border,radius and with hint  44',
                  hasBorder: true,
                  radius: 20,
                  height: 40,
                  hasLabel: false,
                  cursorColor: Clr.colorGreen,
                  fillColor: Clr.colorGreen,
                  borderColor: Clr.colorCyan,
                ),
              ),
              TxtFormInput(
                controller: inputEditingController,
                hintText: 'I am with border,radius and with hint',
                hasBorder: false,
                radius: 20,
                hasLabel: false,
              ),
              const MyDivider(),
              TxtFormInput(
                controller: inputEditingController,
                hintText: 'I am with border,radius, label and with hint',
                hasBorder: true,
                radius: 20,
                height: 45,
                labelText: 'I am label',
                hasLabelOnTop: false,
                hasLabel: true,
                onTap: () {},
              ),
              const MyDivider(),
              TxtFormInput(
                controller: inputEditingController,
                hintText: 'radius, label and with hint',
                hasBorder: true,
                radius: 20,
                labelText: 'I am label and google auto complete',
                hasLabelOnTop: false,
                onChanged: onChange,
              ),
              TxtFormInput(
                borderColor: Clr.colorCyan,
                controller: inputEditingController,
                hasBorder: false,
                fillColor: Clr.colorCyan,
                removeAllBorders: true,
                preFix: IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    formKey.currentState!.validate();
                    debugPrint('I am clickable');
                  },
                ),
                postFix: const Icon(Icons.add),
                radius: 20,
              ),

              const MyDivider(),
              BtnSF(
                text: 'Show Dialog',
                onPressed: () {
                  Dialogs.showCustomDialog(body: const MainWeb());
                },
                bgColor: Clr.colorCyan,
              ),
              const MyDivider(),
              BtnSF(
                text: 'I am button',
                onPressed: () {},
                bgColor: Clr.colorBlack,
              ),

              BtnSF(
                text: 'Check Web View',
                onPressed: () {
                  pSetRout(page: ()=> const MainWeb());
                },
                bgColor: Clr.colorBlack,
              ),
              const MyDivider(),
              TxtFormInput(
                onTap: onSearchAbleDropDownTap,
                hintText: 'Tap here to search from dropdown',
                controller: searchAbleDropDownTap,
              )
            ],
          ),
        ),
      );
  }

  void onChange(String value) {
    const String googleMapsApiKey = 'Mapkey';
    String other = ['components=country:PK', 'new=lahore'].join('&');
    GoogleMapsHelper.getPlaces(value, googleMapsApiKey,
        otherOptions: other);
  }

  void onSearchAbleDropDownTap() {
    pSetRout(
        page: () => SearchableDropdown(
              list: listDropdown,
              multiSelect: true,
              showBottomButton: false,
              refreshList: true,
            ));
  }


}

callHttpError(dynamic error, response, bool? defaultResponse) {
  pShowToast(message: 'error happning');
}
