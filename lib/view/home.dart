import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_manager/api/password_manager/password_manager_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/password_manager/password_manager.dart';
import 'password_manager_pages/add_password_manager.dart';
import 'password_manager_pages/detail_password_manager.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PasswordManagerServiceImpl service = PasswordManagerServiceImpl();
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
                onTap: () {},
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

  Widget PasswordManagerCard(BuildContext context, PasswordManager data) {
    void _delete(String id) async {
      service
          .delete(id)
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
