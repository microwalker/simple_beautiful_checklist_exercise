import 'package:flutter/material.dart';
import 'package:simple_beautiful_checklist_exercise/data/database_repository.dart';
import 'package:simple_beautiful_checklist_exercise/src/features/task_list/widgets/empty_content.dart';
import 'package:simple_beautiful_checklist_exercise/src/features/task_list/widgets/item_list.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({
    super.key,
    required this.repository,
  });

  final DatabaseRepository repository;

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<String> items = [];  // Liste wird ständig geändert, final machte nicht wirlich Sinn !!
  bool isLoading = true;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _updateList();
  }

  void _updateList() async {
    setState(() => isLoading = true ); // <- wurde komplett vergessen, nach dem 1. laden war isLoading IMMER false!

    // items.addAll(await widget.repository.getItems()); // .whenComplete(() => setState(() => isLoading = false )));
    widget.repository.getItems().then((value) {
      items = value;   // Liste erst nach erfolgreichem Auslesen der Werte wieder befüllen !!!
      setState(() => isLoading = false ); // ...und dann macht das Zurücksetzen der Statusvariable auch Sinn :-)
    });
    // isLoading = false;
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meine Checkliste'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: items.isEmpty
                      ? const EmptyContent()
                      : ItemList(
                          repository: widget.repository,
                          items: items,
                          updateOnChange: _updateList,
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Task Hinzufügen',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () async {
                          if (_controller.text.isNotEmpty) {
                            await widget.repository.addItem(_controller.text);
                            _controller.clear();
                            _updateList();
                          }
                        },
                      ),
                    ),
                    onSubmitted: (value) async {
                      if (value.isNotEmpty) {
                        await widget.repository.addItem(value);
                        _controller.clear();
                        _updateList();
                      }
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
