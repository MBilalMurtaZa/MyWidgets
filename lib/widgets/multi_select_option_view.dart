import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_widgets/widgets/dividers.dart';
import 'package:my_widgets/widgets/input.dart';
import 'package:my_widgets/widgets/txt.dart';
import '../../utils/utils.dart';

class MultiSelectDropDown<T> extends StatefulWidget {
  final List<T> items;
  final List<T> selectedItem;
  final String Function(T) itemLabel; // Converts item to string for display
  final Function(List<T>)? onSelectionChanged;
  final bool isMulti;
  final String title;
  final AppBar? appBar;
  final Widget? selectedIconWidget;
  final InputDecoration? searchBarInputDecoration;
  final bool centerTitle;
  final EdgeInsets? padding;

  const MultiSelectDropDown({
    super.key,
    required this.items,
    required this.itemLabel,
    this.onSelectionChanged,
    required this.selectedItem,
    this.isMulti = false,
    this.centerTitle = false,
    this.title = 'Search',
    this.appBar,
    this.selectedIconWidget,
    this.searchBarInputDecoration,
    this.padding,

  });

  @override
  State<MultiSelectDropDown<T>> createState() => MultiSelectOptionViewState<T>();
}

class MultiSelectOptionViewState<T> extends State<MultiSelectDropDown<T>> {
  var searchController = TextEditingController();
  List<T> filteredItems = [];
  final List<T> selectedItems = [];
  @override
  void initState() {
    super.initState();
    filteredItems = widget.items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar??AppBar(title: Txt(widget.title), centerTitle: widget.centerTitle,),
      body: Container(
        padding: widget.padding??EdgeInsets.all(24),
        child: Column(
          children: [
            TxtFormInput(
              controller: searchController,
              hasLabel: false,
              maxLines: 4,
              minLines: 1,
              labelText: 'Search'.tr,
              textSize: 12,
              onChanged: onSearchChange,
              hasLabelOnTop: true,
              labelStyle: TextStyle(
                color: Clr.colorPrimary,
                fontFamily: Static.fontFamily

              ),
              decoration:  widget.searchBarInputDecoration,
            ),
            MyDivider(),
            Expanded(child: ListView.separated(
              shrinkWrap: true,
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                final isSelected = selectedItems.contains(item);
                return ListTile(
                  onTap: () => toggleItem(item),
                  title: Text(widget.itemLabel(item)),
                  trailing: isSelected
                      ? widget.selectedIconWidget ?? const Icon(Icons.check, color: Colors.green)
                      : null,
                );
              }, separatorBuilder: (BuildContext context, int index) => Divider(height: 1,),
            )),
          ],
        ),
      ),
    );
  }

  void onSearchChange(String value) {
    setState(() {
      filteredItems = widget.items
          .where((item) => widget
          .itemLabel(item)
          .toLowerCase()
          .contains(value.toLowerCase()))
          .toList();
    });
  }

  toggleItem(T item) {
    setState(() {
      if (selectedItems.contains(item)) {
        selectedItems.remove(item);
      } else {
        selectedItems.add(item);
      }
      widget.selectedItem.clear();
      widget.selectedItem.addAll(selectedItems);
    });
    if(widget.onSelectionChanged != null)widget.onSelectionChanged!(selectedItems);
    if(!widget.isMulti){
      Get.back();
    }
  }
}
