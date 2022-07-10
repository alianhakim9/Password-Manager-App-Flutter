import 'package:flutter/material.dart';
import 'package:password_manager/viewmodel/main_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPasswordManager extends StatefulWidget {
  const AddPasswordManager({Key? key}) : super(key: key);

  @override
  State<AddPasswordManager> createState() => _AddPasswordManagerState();
}

class _AddPasswordManagerState extends State<AddPasswordManager> {
  String username = '';
  String password = '';
  String website = '';
  bool _isObscure = true;
  bool _isButtonActive = false;
  bool _isLoading = false;
  final bool _pinned = true;
  final bool _snap = false;
  final bool _floating = false;

  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerWebsite = TextEditingController();

  MainViewModel viewModel = MainViewModel();

  @override
  void initState() {
    super.initState();
    _controllerUsername.addListener(() {
      _controllerPassword.addListener(() {
        _controllerWebsite.addListener(() {
          setState(() {
            _isButtonActive = _controllerUsername.text.isNotEmpty &&
                _controllerPassword.text.isNotEmpty;
          });
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
      AddPasswordManager(userId);
    }
  }

  void AddPasswordManager(userId) {
    showLoading();
    viewModel
        .addPasswordManager(username, password, website, userId)
        .then((value) {
      if (value != null) {
        hideLoading();
        Navigator.pop(context);
      } else {
        hideLoading();
        showSnackbar('Gagal menambahkan data');
      }
    }).catchError((err) {
      hideLoading();
      showSnackbar('Terjadi kesalahan saat menambahkan data');
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
              title: Text('Tambah password'),
              background: Icon(
                Icons.key,
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
                            decoration: const InputDecoration(
                              labelText: 'username',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (e) => {username = e},
                            controller: _controllerUsername,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'password',
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isObscure = !_isObscure;
                                    });
                                  },
                                  icon: Icon(_isObscure
                                      ? Icons.visibility
                                      : Icons.visibility_off)),
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(255, 179, 0, 1))),
                            ),
                            onChanged: (e) => {password = e},
                            obscureText: _isObscure,
                            enableSuggestions: false,
                            autocorrect: false,
                            controller: _controllerPassword,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'website',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (e) => {website = e},
                            controller: _controllerWebsite,
                          ),
                        ],
                      ),
                    ))
        ],
      ),
    );
  }
}
