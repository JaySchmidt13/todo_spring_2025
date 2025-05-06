import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../data/todo.dart';
import 'details/detail_screen.dart';
import 'filter/filter_sheet.dart';
import 'package:audioplayers/audioplayers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();
  final _searchController = TextEditingController();
  final _locationController = TextEditingController();
  String _selectedCategory = 'Default';
  StreamSubscription<List<Todo>>? _todoSubscription;
  List<Todo> _todos = [];
  List<Todo>? _filteredTodos;
  final List<String> _categories = ['Default', 'Work', 'Personal', 'Shopping', 'Study'];
  FilterSheetResult _filters = FilterSheetResult(
    sortBy: 'date',
    order: 'descending',
  );

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _todoSubscription = getTodosForUser(user.uid).listen((todos) {
        setState(() {
          _todos = todos;
          _filteredTodos = filterTodos();
        });
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    _todoSubscription?.cancel();
    super.dispose();
  }

  List<Todo> filterTodos() {
    List<Todo> filteredTodos = _todos.where((todo) {
      return todo.text.toLowerCase().contains(_searchController.text.toLowerCase());
    }).toList();

    if (_filters.sortBy == 'date') {
      filteredTodos.sort((a, b) =>
          _filters.order == 'ascending' ? a.createdAt.compareTo(b.createdAt) : b.createdAt.compareTo(a.createdAt));
    } else if (_filters.sortBy == 'completed') {
      filteredTodos.sort((a, b) => _filters.order == 'ascending'
          ? (a.completedAt ?? DateTime(0)).compareTo(b.completedAt ?? DateTime(0))
          : (b.completedAt ?? DateTime(0)).compareTo(a.completedAt ?? DateTime(0)));
    }

    return filteredTodos;
  }

  Stream<List<Todo>> getTodosForUser(String userId) {
    return FirebaseFirestore.instance
        .collection('todos')
        .where('uid', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.map((doc) => Todo.fromSnapshot(doc)).toList());
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isDesktop = constraints.maxWidth > 600;
          return Center(
            child: SizedBox(
              width: isDesktop ? 600 : double.infinity,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        labelText: 'Search TODOs',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.filter_list),
                          onPressed: () async {
                            final result = await showModalBottomSheet<FilterSheetResult>(
                              context: context,
                              builder: (context) {
                                return FilterSheet(initialFilters: _filters);
                              },
                            );

                            if (result != null) {
                              setState(() {
                                _filters = result;
                                _filteredTodos = filterTodos();
                              });
                            }
                          },
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _filteredTodos = filterTodos();
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _filteredTodos?.isEmpty ?? true
                        ? const Center(child: Text('No TODOs found'))
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            itemCount: _filteredTodos?.length ?? 0,
                            itemBuilder: (context, index) {
                              final todo = _filteredTodos?[index];
                              if (todo == null) return const SizedBox.shrink();
                              return ListTile(
                                leading: Checkbox(
                                  value: todo.completedAt != null,
                                  onChanged: (bool? value) async{

                                    if (value == true) {
                                      final player = AudioPlayer();
                                      await player.play(AssetSource('sounds/mission-complete-pikmin-4.mp3')); // Ensure the file path matches the asset declaration
                                    }


                                    final updateData = {
                                      'completedAt': value == true ? FieldValue.serverTimestamp() : null
                                    };
                                    FirebaseFirestore.instance.collection('todos').doc(todo.id).update(updateData);
                                  },
                                ),
                                trailing: Icon(Icons.arrow_forward_ios),
                                title: Text(
                                  todo.text,
                                  style: todo.completedAt != null
                                      ? const TextStyle(decoration: TextDecoration.lineThrough)
                                      : null,
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailScreen(todo: todo),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                  ),
                  Container(
                    color: Colors.green[100],
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          decoration: const InputDecoration(
                            labelText: 'Category',
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          items: _categories.map((String category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedCategory = newValue!;
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _locationController,
                          decoration: const InputDecoration(
                            labelText: 'Location (optional)',
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.text,
                                controller: _controller,
                                decoration: const InputDecoration(
                                  labelText: 'Enter Task',
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () async {
                                if (user != null && _controller.text.isNotEmpty) {

                                  final player = AudioPlayer();
                                  await player.play(AssetSource('African4.mp3')); // Ensure the file path matches the asset declaration

                                  await FirebaseFirestore.instance.collection('todos').add({
                                    'text': _controller.text,
                                    'createdAt': FieldValue.serverTimestamp(),
                                    'uid': user.uid,
                                    'category': _selectedCategory,
                                    'location': _locationController.text.isEmpty ? null : _locationController.text,
                                  });

                                  _controller.clear();
                                  _locationController.clear();
                              }
                              },
                              child: const Text('Add'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
