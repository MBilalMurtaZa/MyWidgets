import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_widgets/dialogs/dialogs.dart';
import 'package:my_widgets/widgets/btn.dart';
import 'package:my_widgets/widgets/dividers.dart';
import 'package:my_widgets/widgets/input.dart';
import 'package:my_widgets/widgets/snack_bar.dart';


class MainWeb extends StatefulWidget {
  const MainWeb({super.key});

  @override
  State<MainWeb> createState() => _MainWebState();
}

class _MainWebState extends State<MainWeb> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Center(
            child: Container(
              width: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TxtFormInput(
                    hintText: 'Password',
                    hasLabelOnTop: false,
                    borderColor: Colors.blueAccent.shade100,
                    isPassword: true,
                  ),
                  const MyDivider(),
                  TxtFormInput(
                    hintText: 'Input',
                    hasLabelOnTop: false,
                    borderColor: Colors.blueAccent.shade100,
                    isOptional: false,
                    labelText: 'Input',
                    hasLabel: true,
                  ),
                  const MyDivider(),
                  TxtFormInput(
                    hintText: 'Plane Input',
                    hasLabelOnTop: false,
                    borderColor: Colors.blueAccent.shade100,
                  ),
                  const MyDivider(),
                  TxtFormInput(
                    hintText: 'Prefix input',
                    hasLabelOnTop: false,
                    preFix: Icon(Icons.person_2_outlined, color: Colors.blueAccent.shade100),
                  ),
                  const MyDivider(),
                  TxtFormInput(
                    hintText: 'Postfix input',
                    hasLabelOnTop: false,
                    postFix: Icon(Icons.person_2_outlined, color: Colors.blueAccent.shade100),
                  ),
                  const MyDivider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Btn(
                        text: 'Click me for dialog',
                        onPressed: (fn) async {
                          fn(true);
                          // await Dialogs.showNativeDialog(title: 'Info',message: 'You clicked at left button');
                          await Future.delayed(3.seconds);
                          fn(false);
                        },
                        borderWidth: 0.3,
                        hasBorder: true,
                        borderColor: Colors.blueAccent,
                        textColor: Colors.blueAccent,
                        radius: 6,
                        bgColor: Colors.white,
                        shadowColor: Colors.white,
                        preFix: const Icon(Icons.add),
                        makeInverse: true,
                      ),
                      const Spacer(),
                      Btn(
                        text: 'Click me for alert',
                        postFix: const Icon(Icons.add,),
                        onPressed: (fn) async {
                          fn(true);
                          await ShowSnackBar().createHighlightOverlay(
                            text: 'Hello I am alert',
                            context: context,
                            textColor: Colors.white,
                            hasCloseIcon: true,
                          );
                          fn(false);
                        },
                        bgColor: Colors.blueAccent,
                        textColor: Colors.white,
                        radius: 6,
                      ),
                    ],
                  ),

                  const MyDivider(),
                  switchButton(),
                ],
              ),
            ),
          ),
        ),

      ],
    );
  }

  bool switchValue = true;
  switchButton(){

    return Switch(
      activeColor: Colors.blueAccent,
      value: switchValue, onChanged: (bool value) {
      setState(() {
        switchValue = !switchValue;
      });
    },

    );
  }
}
