import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:password_manager/api/notes/note_req_res.dart';
import 'package:password_manager/api/notes/note_service.dart';
import 'package:password_manager/view/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:password_manager/utils/helper.dart' as global;

class AddNotePage extends StatefulWidget {
  const AddNotePage({Key? key}) : super(key: key);

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  String noteTitle = '';
  String noteDescription = '';
  bool _isLoading = false;
  final bool _pinned = true;
  final bool _snap = false;
  final bool _floating = false;

  final TextEditingController _controllerTitle = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();

  final NoteServiceImpl service = NoteServiceImpl();

  @override
  void dispose() {
    _controllerTitle.dispose();
    _controllerDescription.dispose();
    super.dispose();
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
    if (noteTitle != '' && noteDescription != '') {
      showLoading();
      service.create(request).then((value) {
        if (value != null) {
          hideLoading();
          Navigator.pop(context);
          hideLoading();
          global.showSnackbar(context, 'Data berhasil ditambahkan');
          Future.delayed(const Duration(milliseconds: 2000), () {
            setState(() {
              global.customPushRemoveNavigator(context, const HomePage());
            });
          });
        } else {
          hideLoading();
          log('value ${value!.data}');
          global.showSnackbar(context, 'Gagal menambahkan data');
        }
      }).onError((error, stackTrace) {
        hideLoading();
        global.showSnackbar(context, 'Terjadi kesalahan saat menambahkan data');
        log('error : $error');
      });
    } else {
      global.showSnackbar(context, 'Tidak boleh kosong');
    }
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
              title: Text(
                'Tambah Catatan',
                style: TextStyle(fontSize: 15),
              ),
              centerTitle: true,
              background: Icon(
                Icons.note_add,
                size: 100.0,
              ),
            ),
            backgroundColor: Colors.amber[600],
          ),
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                TextFormField(
                  onChanged: (e) => {noteTitle = e},
                  controller: _controllerTitle,
                  decoration: const InputDecoration(label: Text('Title')),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                TextFormField(
                  onChanged: (e) => {noteDescription = e},
                  enableSuggestions: false,
                  autocorrect: false,
                  controller: _controllerDescription,
                  maxLines: MediaQuery.of(context).size.height.toInt(),
                  decoration:
                      const InputDecoration.collapsed(hintText: "Deskripsi"),
                ),
              ],
            ),
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading
            ? null
            : () {
                addData();
              },
        backgroundColor: Colors.grey[800],
        child: _isLoading
            ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  color: Colors.amber[600],
                ))
            : const Icon(
                Icons.add,
                color: Colors.white,
              ),
      ),
    );
  }
}
