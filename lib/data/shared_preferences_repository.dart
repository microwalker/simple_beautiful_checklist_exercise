import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_beautiful_checklist_exercise/data/database_repository.dart';

const key = "p19_tasks";

class SharedPreferencesRepository implements DatabaseRepository {
  SharedPreferencesAsync prefs = SharedPreferencesAsync();
  
  @override
  Future<int> getItemCount() async {
    // await Future.delayed(const Duration(milliseconds: 100));
    return (await prefs.getStringList(key) ?? []).length;
  }

  @override
  Future<List<String>> getItems() async {
    // await Future.delayed(const Duration(milliseconds: 100));
    return (await prefs.getStringList(key) ?? []); 
  }

  @override
  Future<void> addItem(String item) async {
    //make sure item doesn't exist yet and is not empty
    List<String> items = await getItems();
    if (item.isNotEmpty && !items.contains(item)) {
      items.add(item);
      prefs.setStringList(key, items);
    }
  }

  @override
  Future<void> deleteItem(int index) async {
    List<String> items = await getItems();
    items.removeAt(index);
    prefs.setStringList(key, items);
  }

  @override
  Future<void> editItem(int index, String newItem) async {
    List<String> items = await getItems();
    // make sure not empty and not same as other
    if (newItem.isNotEmpty && !items.contains(newItem)) {
      items[index] = newItem;
      prefs.setStringList(key, items);
    }
  }
}
