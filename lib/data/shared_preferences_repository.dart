import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_beautiful_checklist_exercise/data/database_repository.dart';

const key = "p19_tasks";

class SharedPreferencesRepository implements DatabaseRepository {
  SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();
  
  @override
  Future<int> getItemCount() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    
    await Future.delayed(const Duration(milliseconds: 500));
    return (await asyncPrefs.getStringList(key) ?? []).length; // then((value) => (value ?? []).length);
  }

  @override
  Future<List<String>> getItems() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    
    await Future.delayed(const Duration(milliseconds: 500));
    return await asyncPrefs.getStringList(key) ?? []; // then((value) => value ?? []); 
  }

  @override
  Future<void> addItem(String item) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();

    //make sure item doesn't exist yet and is not empty
    List<String> items = await getItems();
    if (item.isNotEmpty && !items.contains(item)) {
      items.add(item);
      await asyncPrefs.setStringList(key, items);
    }
  }

  @override
  Future<void> deleteItem(int index) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> items = await getItems();
    items.removeAt(index);
    await asyncPrefs.setStringList(key, items);
  }

  @override
  Future<void> editItem(int index, String newItem) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> items = await getItems();
    // make sure not empty and not same as other
    if (newItem.isNotEmpty && !items.contains(newItem)) {
      items[index] = newItem;
      await asyncPrefs.setStringList(key, items);
    }
  }
}
