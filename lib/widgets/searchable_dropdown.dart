// This file is part of a Flutter package created by Bilal MurtaZa.
// Purpose: This file contains searchable dropdown.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_widgets/my_widgets.dart';
import 'package:my_widgets/widgets/btn.dart';
import 'package:my_widgets/widgets/dividers.dart';
import '../utils/utils.dart';
import 'search_bar_text_input.dart';

class SearchableDropdown extends StatelessWidget {
  final List<SearchListModel> list;
  final PreferredSizeWidget? appBar;
  final bool multiSelect;
  final Icon? selectIcon;
  final Icon? confirmIcon;
  final Color? selectedIconColor;
  final Color? bottomButtonColor;
  final double? bottomButtonWidth;
  final bool? bottomButtonHasBorder;
  final Color? bottomButtonBorderColor;
  final String appBarText;
  final String confirmButtonText;
  final String searchBarHintText;
  final String searchBarLabelText;
  final bool showSearchBarLabel;
  final bool showBottomButton;
  final bool refreshList;

  const SearchableDropdown(
      {super.key,
      required this.list,
      this.appBar,
      this.multiSelect = false,
      this.selectIcon,
      this.selectedIconColor,
      this.appBarText = 'Search',
      this.searchBarHintText = 'Search',
      this.searchBarLabelText = 'Search',
      this.showSearchBarLabel = true,
      this.confirmIcon,
      this.showBottomButton = false,
      this.confirmButtonText = 'Select',
      this.bottomButtonColor,
      this.bottomButtonWidth,
      this.bottomButtonHasBorder,
      this.bottomButtonBorderColor,
      this.refreshList = false});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchableController>(
      init: SearchableController(list, multiSelect, refreshList),
      builder: (controller) {
        return GestureDetector(
          onTap: pFocusOut,
          child: Scaffold(
            appBar: appBar ??
                AppBar(
                  title: Text(
                    appBarText,
                  ),
                  actions: [
                    if (multiSelect)
                      IconButton(
                          onPressed: controller.onSavePressed,
                          icon: confirmIcon ?? const Icon(Icons.check))
                  ],
                ),
            body: Column(
              children: [
                SearchBarInput(
                  controller: controller.searchTxt,
                  onChange: controller.onSearch,
                  hintText: searchBarHintText,
                  labelText: searchBarLabelText,
                  showLabel: showSearchBarLabel,
                ),
                const MyDivider(),
                Expanded(
                  child: Obx(
                    () => ListView.separated(
                      itemBuilder: (context, index) {
                        final item = controller.filteredList[index];
                        return GetBuilder<SearchableController>(
                            id: 'item',
                            builder: (logic) {
                              return GestureDetector(
                                child: item.widget ??
                                    ListTile(
                                      leading: multiSelect
                                          ? selectIcon ??
                                              Icon(
                                                Icons.check,
                                                color: item.isSelected()
                                                    ? selectedIconColor ??
                                                        Clr.colorGreen
                                                    : Clr.colorWhite,
                                              )
                                          : null,
                                      title: Text(item.name ?? ''),
                                    ),
                                onTap: () => controller.onItemTap(item),
                              );
                            });
                      },
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: controller.filteredList.length,
                    ),
                  ),
                ),
                if (showBottomButton && multiSelect) ...[
                  BtnSF(
                      text: confirmButtonText,
                      onPressed: controller.onSavePressed,
                      width: bottomButtonWidth ?? Get.width * 0.8,
                      bgColor: bottomButtonColor,
                      hasBorder: bottomButtonHasBorder ?? false,
                      borderColor: bottomButtonColor),
                  const SafeArea(child: MyDivider()),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class SearchableController extends GetxController {
  final List<SearchListModel> list;

  var searchTxt = TextEditingController();
  final bool multiSelect;
  final bool refreshList;

  SearchableController(this.list, this.multiSelect, this.refreshList);

  var filteredList = <SearchListModel>[].obs;

  @override
  void onInit() {
    if (refreshList) {
      for (var element in list) {
        element.isSelected(false);
      }
    }
    filteredList.assignAll(list);

    super.onInit();
  }

  void onSearch(String value) {
    if (value.isEmpty) {
      filteredList.assignAll(list);
    } else {
      filteredList.assignAll(list.where((element) =>
          (element.name ?? '').toLowerCase().contains(value.toLowerCase())));
    }
  }

  void onItemTap(SearchListModel item) {
    if (multiSelect) {
      item.isSelected(!item.isSelected());
      update(['item']);
    } else {
      Get.back(result: item);
    }
  }

  void onSavePressed() {
    Get.back(result: list.where((element) => element.isSelected()));
  }
}

class SearchListModel {
  String? name;
  dynamic id;
  Widget? widget;
  var isSelected = false.obs;

  SearchListModel({this.name, this.id, this.widget});
}
