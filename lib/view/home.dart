import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:password_manager/api/notes/note_service.dart';
import 'package:password_manager/api/password_manager/password_manager_service.dart';
import 'package:password_manager/api/personal_info/personal_info_service.dart';
import 'package:password_manager/cards/note_card.dart';
import 'package:password_manager/cards/password_manager_card.dart';
import 'package:password_manager/cards/personal_info_card.dart';
import 'package:password_manager/view/note_pages/add_note_page.dart';
import 'package:password_manager/view/password_generator.dart';
import 'package:password_manager/view/password_manager_pages/add_password_manager_page.dart';
import 'package:password_manager/view/personal_info_pages/add_personal_info_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:password_manager/utils/helper.dart' as global;
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PasswordManagerServiceImpl service = PasswordManagerServiceImpl();
  final NoteServiceImpl noteService = NoteServiceImpl();
  final PersonalInfoServiceImpl personalInfoService = PersonalInfoServiceImpl();

  List passwords = [];
  List notes = [];
  List personalInfos = [];
  bool _showLoading = false;
  String userId = '';
  String username = '';

  Future getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var usernamePrefs = prefs.getString('username');
    if (usernamePrefs != null) {
      username = usernamePrefs.toString();
    }
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

      personalInfoService.get(id).then((value) {
        if (value != null) {
          setState(() {
            hideLoading();
            personalInfos = value;
          });
        }
      }).catchError((err) {
        hideLoading();
        log('note service error :$err');
      });
    });
  }

  @override
  void initState() {
    getData();
    getUsername();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('HomePage'),
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
          backgroundColor: Colors.amber[600],
        ),
        body: TabBarView(
          children: [
            HomeBody(
                context,
                _showLoading,
                () => getData(),
                passwords,
                ListView.builder(
                  padding: const EdgeInsets.only(
                      bottom: kFloatingActionButtonMargin + 48),
                  itemBuilder: (context, i) {
                    return PasswordManagerCard(context, passwords[i]);
                  },
                  itemCount: passwords.length,
                ),
                'Tambah password', () {
              global.customPushOnlyNavigator(
                  context, const AddPasswordManager());
            }),
            HomeBody(
                context,
                _showLoading,
                () => getData(),
                notes,
                ListView.builder(
                  padding: const EdgeInsets.only(
                      bottom: kFloatingActionButtonMargin + 48),
                  itemBuilder: (context, i) {
                    return NoteCard(context, notes[i]);
                  },
                  itemCount: notes.length,
                ),
                'Tambah Catatan', () {
              global.customPushOnlyNavigator(context, const AddNotePage());
            }),
            HomeBody(
                context,
                _showLoading,
                () => getData(),
                personalInfos,
                ListView.builder(
                  padding: const EdgeInsets.only(
                      bottom: kFloatingActionButtonMargin + 48),
                  itemBuilder: (context, i) {
                    return PersonalInfoCard(context, personalInfos[i], i);
                  },
                  itemCount: personalInfos.length,
                ),
                'Tambah Personal Info', () {
              global.customPushOnlyNavigator(
                  context, const AddPersonalInfoPage());
            }),
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
                      backgroundImage: const AssetImage(
                          'assets/illustrations/logo_only.png'),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
                child: Text(
                  username,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
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
                  global.customPushOnlyNavigator(
                      context, const PasswordGeneratorPages());
                },
              ),
            ],
          )),
        ),
      ),
    );
  }
}

Widget HomeBody(BuildContext context, bool isLoading, Future Function() refresh,
    List data, Widget listView, String floatingLabel, VoidCallback onPressed) {
  return Scaffold(
    body: isLoading
        ? Padding(
            padding: const EdgeInsets.all(10.0),
            child: Shimmer.fromColors(
              baseColor: const Color.fromRGBO(224, 224, 224, 1),
              highlightColor: const Color.fromRGBO(158, 158, 158, 1),
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                        height: 50,
                        color: Colors.grey[300],
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      flex: 4,
                      child: Container(
                        height: 50,
                        color: Colors.grey[300],
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      flex: 1,
                      child: Container(
                        height: 50,
                        color: Colors.grey[300],
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      flex: 1,
                      child: Container(
                        height: 50,
                        color: Colors.grey[300],
                      )),
                ],
              ),
            ),
          )
        : RefreshIndicator(
            onRefresh: refresh,
            child: data.isEmpty
                ? Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Data masih kosong'),
                      TextButton(
                        onPressed: () {
                          refresh();
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        child: const Text("Refresh"),
                      )
                    ],
                  ))
                : listView),
    floatingActionButton: FloatingActionButton.extended(
        onPressed: onPressed,
        label: Text(
          floatingLabel,
          style: const TextStyle(color: Colors.white),
        ),
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.grey[800]),
  );
}
