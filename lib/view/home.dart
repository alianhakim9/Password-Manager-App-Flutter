import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:password_manager/view/password_manager_pages/add_password_manager.dart';
import 'package:password_manager/viewmodel/main_viewmodel.dart';
import 'package:password_manager/widgets/password_manager_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final MainViewModel viewModel = MainViewModel();
  List passwords = [];
  bool _showLoading = false;

  void showLoading() {
    setState(() {
      _showLoading = true;
    });
  }

  void hideLoading() {
    setState(() {
      _showLoading = false;
    });
  }

  void getPasswords(userId) async {
    showLoading();
    viewModel.getPasswordManager(userId).then((value) {
      setState(() {
        hideLoading();
        passwords = value;
      });
    }).catchError((errr) {
      hideLoading();
      log('error : $errr');
    });
  }

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userId') ?? false;
    if (userId != '') {
      getPasswords(userId);
    }
  }

  void clearShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future refreshData() async {
    getData();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() async {
    super.dispose();
    clearShared();
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
                      onRefresh: refreshData,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(
                            bottom: kFloatingActionButtonMargin + 48),
                        itemBuilder: (context, i) {
                          return PasswordManagerCard(passwords[i]);
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
}
