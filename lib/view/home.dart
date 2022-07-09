import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          backgroundColor: Colors.amber[600],
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.key),
              ),
              Tab(
                icon: Icon(Icons.book),
              ),
              Tab(
                icon: Icon(Icons.personal_injury),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Scaffold(
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {},
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
                children: [Text('test')],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
