import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:password_manager/api/notes/note_req_res.dart';
import 'package:password_manager/api/notes/note_service.dart';
import 'package:password_manager/view/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({Key? key}) : super(key: key);

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  String noteTitle = '';
  String noteDescription = '';
  bool _isButtonActive = false;
  bool _isLoading = false;
  final bool _pinned = true;
  final bool _snap = false;
  final bool _floating = false;

  final TextEditingController _controllerTitle = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();

  final NoteServiceImpl service = NoteServiceImpl();

  @override
  void initState() {
    super.initState();
    _controllerTitle.addListener(() {
      _controllerDescription.addListener(() {
        setState(() {
          _isButtonActive = _controllerTitle.text.isNotEmpty &&
              _controllerDescription.text.isNotEmpty;
        });
      });
    });
  }

  void showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  void hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  addData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userId') ?? false;
    if (userId != '') {
      addNote(userId);
    }
  }

  void addNote(userId) async {
    AddUpdateNoteRequest request = AddUpdateNoteRequest(
        noteTitle: noteTitle, noteDescription: noteDescription, userId: userId);
    showLoading();
    service.create(request).then((value) {
      if (value != null) {
        hideLoading();
        Navigator.pop(context);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const Home()),
            (route) => false);
      } else {
        hideLoading();
        log('value ${value!.data}');
        showSnackbar('Gagal menambahkan data');
      }
    }).onError((error, stackTrace) {
      hideLoading();
      showSnackbar('Terjadi kesalahan saat menambahkan data');
      log('error : $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: _pinned,
            snap: _snap,
            floating: _floating,
            expandedHeight: 160.0,
            flexibleSpace: const FlexibleSpaceBar(
              title: Text('Tambah Catatan'),
              background: Icon(
                Icons.note_add_outlined,
                size: 50,
              ),
            ),
            actions: [
              if (_isButtonActive)
                IconButton(
                    onPressed: () {
                      addData();
                    },
                    icon: const Icon(Icons.done))
            ],
          ),
          SliverToBoxAdapter(
              child: _isLoading
                  ? const LinearProgressIndicator()
                  : Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration.collapsed(
                                hintText: "Title"),
                            onChanged: (e) => {noteTitle = e},
                            controller: _controllerTitle,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            onChanged: (e) => {noteDescription = e},
                            enableSuggestions: false,
                            autocorrect: false,
                            controller: _controllerDescription,
                            maxLines:
                                MediaQuery.of(context).size.height.toInt(),
                            decoration: const InputDecoration.collapsed(
                                hintText: "Deskripsi"),
                          ),
                        ],
                      ),
                    ))
        ],
      ),
    );
  }
}
