// ignore_for_file: must_be_immutable, no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:password_manager/api/notes/note_req_res.dart';
import 'package:password_manager/api/notes/note_service.dart';
import 'package:password_manager/model/note_model.dart';
import 'package:password_manager/view/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:password_manager/utils/helper.dart' as global;

class UpdateNotePage extends StatefulWidget {
  UpdateNotePage({Key? key, required this.data}) : super(key: key);

  Note data;

  @override
  State<UpdateNotePage> createState() => _UpdateNotePageState(data);
}

class _UpdateNotePageState extends State<UpdateNotePage> {
  Note? data;
  _UpdateNotePageState(this.data);

  String title = '';
  String description = '';
  bool _showLoading = false;

  final TextEditingController _controllerTitle = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();
  final NoteServiceImpl service = NoteServiceImpl();

  @override
  void initState() {
    super.initState();
    _controllerTitle.text = data!.noteTitle;
    _controllerDescription.text = data!.noteDescription;

    title = data!.noteTitle;
    description = data!.noteDescription;
  }

  @override
  void dispose() {
    _controllerTitle.dispose();
    _controllerDescription.dispose();
    super.dispose();
  }

  showLoading() {
    setState(() {
      _showLoading = true;
    });
  }

  hideLoading() {
    setState(() {
      _showLoading = false;
    });
  }

  _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('userId');
    return id;
  }

  _update() async {
    showLoading();
    _getUserId().then((id) {
      AddUpdateNoteRequest request = AddUpdateNoteRequest(
          noteTitle: title, noteDescription: description, userId: id);
      service.update(request, data!.id).then((value) {
        hideLoading();
        global.showSnackbar(context, 'Data berhasil di update');
        Future.delayed(const Duration(milliseconds: 2000), () {
          setState(() {
            global.customPushRemoveNavigator(context, const HomePage());
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubah Note'),
        backgroundColor: Colors.amber[600],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                onChanged: (e) => title = e,
                controller: _controllerTitle,
                decoration: const InputDecoration(label: Text('Title')),
              ),
              TextField(
                maxLines: 20,
                onChanged: (e) => description = e,
                controller: _controllerDescription,
                decoration: const InputDecoration(label: Text('Deskripsi')),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      minimumSize: const Size.fromHeight(50),
                      elevation: 0),
                  onPressed: _showLoading
                      ? null
                      : () {
                          _update();
                        },
                  icon: _showLoading
                      ? Container(
                          width: 16,
                          height: 16,
                          margin: const EdgeInsets.only(right: 30),
                          child: CircularProgressIndicator(
                            color: Colors.grey[800],
                          ))
                      : const Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                  label: _showLoading
                      ? const Text(
                          'Sedang menyimpan data...',
                          style: TextStyle(color: Colors.white),
                        )
                      : const Text(
                          'Simpan',
                          style: TextStyle(color: Colors.white),
                        ))
            ],
          ),
        ),
      ),
    );
  }
}
