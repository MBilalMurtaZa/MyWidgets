import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_widgets/my_widgets.dart';
import 'package:my_widgets/widgets/dividers.dart';
import 'search_bar.dart';



class SearchableDropdown extends StatelessWidget {
  final List<SearchListModel> list;
  const SearchableDropdown({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchableController>(
      init: SearchableController(list),
      builder: (controller) {
        return GestureDetector(
          onTap: pFocusOut,
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Search"),
            ),
            body: Column(
              children: [
                SearchBar(
                  controller: controller.searchTxt,
                  onChange: controller.onSearch,
                ),
                const MyDivider(),
                Expanded(
                  child: Obx(()=> ListView.separated(
                    itemBuilder: (context, index) {
                      final item = controller.filteredList[index];
                      return ListTile(
                        title: Text(item.name ?? ''),
                        onTap: ()=> controller.onItemTap(item),
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: controller.filteredList.length,
                  ),),
                )
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

  SearchableController(this.list);

  var filteredList = <SearchListModel>[].obs;

  @override
  void onInit() {
    filteredList.assignAll(list);
    super.onInit();
  }

  void onSearch(String value) {
    if(value.isEmpty){
      filteredList.assignAll(list);
    }else{
      filteredList.assignAll(list.where((element) => (element.name??'').toLowerCase().contains(value.toLowerCase())));
    }
  }

  void onItemTap(SearchListModel item) {
    Get.back(result: item);

  }
}
class SearchListModel{
  String? name;
  int id;

  SearchListModel(this.name, this.id);
}
