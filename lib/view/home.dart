import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:password_manager/api/notes/note_service.dart';
import 'package:password_manager/api/password_manager/password_manager_service.dart';
import 'package:password_manager/cards/note_card.dart';
import 'package:password_manager/view/note_pages/add_note_page.dart';
import 'package:password_manager/view/password_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cards/password_manager_card.dart';
import 'password_manager_pages/add_password_manager_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PasswordManagerServiceImpl service = PasswordManagerServiceImpl();
  final NoteServiceImpl noteService = NoteServiceImpl();
  List passwords = [];
  List notes = [];
  bool _showLoading = false;
  String userId = '';

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

  Future getData() async {
    showLoading();
    _getUserId().then((id) {
      service
          .get(id)
          .then((value) => {
                if (value != null)
                  {
                    setState(() {
                      hideLoading();
                      passwords = value;
                    })
                  }
              })
          .catchError((err) {
        hideLoading();
        log('Err : $err');
      });

      noteService.get(id).then((value) {
        if (value != null) {
          setState(() {
            hideLoading();
            notes = value;
          });
        }
        log('note : $id');
      }).catchError((err) {
        hideLoading();
        log('note service error :$err');
      });
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          bottom: const TabBar(
            indicatorColor: Color.fromRGBO(66, 66, 66, 1),
            isScrollable: true,
            tabs: [
              Tab(text: 'PASSWORDS'),
              Tab(
                text: 'CATATAN',
              ),
              Tab(
                text: 'PERSONAL INFO',
              ),
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_outlined))
          ],
        ),
        body: TabBarView(
          children: [
            Scaffold(
              body: _showLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      onRefresh: getData,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(
                            bottom: kFloatingActionButtonMargin + 48),
                        itemBuilder: (context, i) {
                          return PasswordManagerCard(context, passwords[i]);
                        },
                        itemCount: passwords.length,
                      ),
                    ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddPasswordManager()));
                },
                label: const Text(
                  'Tambah Password',
                  style: TextStyle(color: Colors.white),
                ),
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                backgroundColor: Colors.grey[800],
              ),
            ),
            Scaffold(
              body: _showLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      onRefresh: getData,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(
                            bottom: kFloatingActionButtonMargin + 48),
                        itemBuilder: (context, i) {
                          // tambah kondisi if empty
                          return NoteCard(context, notes[i]);
                        },
                        itemCount: notes.length,
                      ),
                    ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddNotePage()));
                },
                label: const Text(
                  'Tambah Catatan',
                  style: TextStyle(color: Colors.white),
                ),
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                backgroundColor: Colors.grey[800],
              ),
            ),
            Scaffold(
              body: _showLoading
                  ? const CircularProgressIndicator()
                  : RefreshIndicator(
                      onRefresh: getData,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(
                            bottom: kFloatingActionButtonMargin + 48),
                        itemBuilder: (context, i) {
                          return PasswordManagerCard(context, passwords[i]);
                        },
                        itemCount: passwords.length,
                      ),
                    ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {},
                label: const Text(
                  'Tambah Personal Info',
                  style: TextStyle(color: Colors.white),
                ),
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                backgroundColor: Colors.grey[800],
              ),
            ),
          ],
        ),
        drawer: Drawer(
          child: SafeArea(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 30, left: 30, right: 30, bottom: 10),
                    child: CircleAvatar(
                      backgroundColor: Colors.amber[600],
                      radius: 30,
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 30, right: 30, top: 10),
                child: Text(
                  'Alian Hakim',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 20,
                child: Divider(
                  height: 5,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.generating_tokens),
                title: const Text('Password Generator'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const PasswordGeneratorPages()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Pengaturan'),
                onTap: () {},
              ),
            ],
          )),
        ),
      ),
    );
  }
}
