import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_widgets/utils/utils.dart';
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

  Color btnBG = Colors.green;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Center(
            child: SizedBox(
              width: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Wrap(
                    direction: Axis.horizontal,
                    children: [
                      Btn(text: 'Help', bgColor: btnBG,onPressed: (){
                        if(btnBG == Colors.green){
                          btnBG = Colors.red;
                        }else{
                          btnBG = Colors.green;
                        }
                      },
                      isLoose: false,),
                      Btn(text: 'Help', bgColor: btnBG,onPressed: (){
                        if(btnBG == Colors.green){
                          btnBG = Colors.red;
                        }else{
                          btnBG = Colors.green;
                        }
                        setState(() {

                        });
                      },),
                    ],
                  ),
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
                      BtnSF(
                        text: 'Click me for dialog',
                        onPressedCallBack: (fn)=>onPressed(fn),
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
                      BtnSF(
                        text: 'Click me for alert',
                        postFix: const Icon(Icons.add,),
                        onPressedCallBack: (fn)=> onAlertTap(fn),
                        bgColor: Colors.blueAccent,
                        textColor: Colors.white,
                        makeInverse: true,
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

  onPressed(Function(bool p1) fn) async {
    fn(true);
    await Future.delayed(5.seconds);
    fn(false);
  }

  onAlertTap(Function(bool p1) fn) async {
    fn(true);
    await Future.delayed(5.seconds);
    fn(false);

    await ShowSnackBar.createHighlightOverlay(
      text: 'Hello I am alert',
      context: context,
      textColor: Colors.white,
      hasCloseIcon: true,
    );

  }
}
