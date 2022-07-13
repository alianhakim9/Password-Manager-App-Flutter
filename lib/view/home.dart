import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/password_manager/password_manager.dart';
import '../viewmodel/main_viewmodel.dart';
import 'password_manager_pages/add_password_manager.dart';
import 'password_manager_pages/detail_password_manager.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final MainViewModel viewModel = MainViewModel();
  List passwords = [];
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

  Future getPasswords() async {
    showLoading();
    _getUserId().then((id) {
      viewModel.getPasswordManager(id).then((value) {
        setState(() {
          hideLoading();
          passwords = value;
        });
      }).catchError((errr) {
        hideLoading();
        log('error : $errr');
      });
    });
  }

  @override
  void initState() {
    getPasswords();
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
                  ? const LinearProgressIndicator()
                  : RefreshIndicator(
                      onRefresh: getPasswords,
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
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {},
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
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [Text('test')],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget PasswordManagerCard(BuildContext context, PasswordManager data) {
    void _delete(String id) {
      viewModel
          .deletePasswordManager(id)
          .then((value) => getPasswords())
          .catchError((err) => log('error $err'));
    }

    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(data.pmUsername),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('Apakah anda yakin akan menghapus data ini?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Hapus'),
                onPressed: () {
                  // hapus data
                  _delete(data.id);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailPasswordManager(
                      data: data,
                    ))),
        child: Row(
          children: [
            const Expanded(
              flex: 1,
              child: Icon(Icons.key),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      data.pmWebsite,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(data.pmUsername)
                  ],
                )),
            Expanded(
                flex: 2,
                child: IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: data.pmPassword))
                          .then((value) => ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  content: Text('Password berhasil di copy'))));
                    },
                    icon: const Icon(Icons.copy))),
            Expanded(
                flex: 1,
                child: PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                        value: 1,
                        child: Row(
                          children: const [
                            Icon(Icons.delete),
                            SizedBox(
                              width: 20,
                            ),
                            Text('Hapus')
                          ],
                        ))
                  ],
                  onSelected: (value) {
                    if (value == 1) {
                      _showMyDialog();
                    }
                  },
                )),
          ],
        ),
      ),
    );
  }
}
