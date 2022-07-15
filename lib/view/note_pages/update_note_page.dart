import 'package:flutter/material.dart';
import 'package:password_manager/api/notes/note_req_res.dart';
import 'package:password_manager/api/notes/note_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/note_model.dart';
import '../home.dart';

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
  bool _hideLoading = false;

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
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Home()),
            (route) => false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubah Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (_showLoading) const LinearProgressIndicator(),
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
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    _update();
                  },
                  child: const Text(('Simpan')),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
