import 'package:flutter/material.dart';
import 'package:my_widgets/utils/utils.dart';
import 'package:my_widgets/widgets/dividers.dart';
import 'package:my_widgets/widgets/input.dart';


class SearchBar extends StatelessWidget {
  final dynamic controller;
  final ValueChanged<String>? onChange;
  final String? hintText;
  final VoidCallback? onSearchPressed;

  const SearchBar({Key? key, this.controller, this.onChange, this.hintText = 'Search',this.onSearchPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TxtFormInput(
              controller: controller,
              maxLines: 1,
              textInputAction: TextInputAction.search,
              keyboardType: TextInputType.text,
              onChanged: onChange,
              hintText: hintText,
              hintTextSize: 18,
              onEditingComplete: onSearchPressed??(){},
              isOptional: true,
              hasBorder: true,
              postFix: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.search, color: Clr.colorPrimary,),
                    onPressed: onSearchPressed??(){},
                  ),
                  const MyVerticalDivider(width: 8,),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
