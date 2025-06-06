import 'package:flutter/material.dart';
import 'package:simple_beautiful_checklist_exercise/data/database_repository.dart';

class ItemList extends StatelessWidget {
  const ItemList({
    super.key,
    required this.repository,
    required this.items,
    required this.updateOnChange,
  });

  final DatabaseRepository repository;
  final List<String> items;
  final void Function() updateOnChange;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(items[index]),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  TextEditingController editController = TextEditingController(
                    text: items[index],
                  );
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Task bearbeiten'),
                        content: TextField(
                          autofocus: true,
                          controller: editController,
                          decoration: const InputDecoration(
                            hintText: "Task bearbeiten",
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: const Text('Abbrechen'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Speichern'),
                            onPressed: () {
                              repository.editItem(index, editController.text).whenComplete(() {
                                updateOnChange();   // Update macht erst nach erfolgreicher Änderung Sinn !!!
                              },);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  repository.deleteItem(index).then((value) => updateOnChange()); // Hier auch erst nach erfolgreichem Löschen !!!
                  // updateOnChange();
                },
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(
        thickness: 1,
        color: Colors.white10,
      ),
    );
  }
}
