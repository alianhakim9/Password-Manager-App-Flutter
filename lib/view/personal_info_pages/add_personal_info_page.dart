// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/api/personal_info/personal_info_req_res.dart';
import 'package:password_manager/api/personal_info/personal_info_service.dart';
import 'package:password_manager/view/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:password_manager/utils/helper.dart' as global;

class AddPersonalInfoPage extends StatefulWidget {
  const AddPersonalInfoPage({Key? key}) : super(key: key);

  @override
  State<AddPersonalInfoPage> createState() => _AddPersonalInfoPageState();
}

class _AddPersonalInfoPageState extends State<AddPersonalInfoPage> {
  String address = '';
  String phoneNumber = '';
  String website = '';
  String email = '';
  bool _isLoading = false;
  final bool _pinned = true;
  final bool _snap = false;
  final bool _floating = false;

  final TextEditingController _controlleraddress = TextEditingController();
  final TextEditingController _controllerPhoneNumber = TextEditingController();
  final TextEditingController _controllerWebsite = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();

  final PersonalInfoServiceImpl service = PersonalInfoServiceImpl();

  @override
  void dispose() {
    _controlleraddress.dispose();
    _controllerPhoneNumber.dispose();
    _controllerWebsite.dispose();
    _controllerEmail.dispose();
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
      addPersonalInfoPage(userId);
    }
  }

  void addPersonalInfoPage(userId) async {
    AddPersonalInfoRequest request = AddPersonalInfoRequest(
        piAddress: address,
        piPhoneNumber: phoneNumber,
        piWebsite: website,
        piEmail: email,
        userId: userId);
    if (address != '' && phoneNumber != '' && website != '' && email != '') {
      showLoading();
      if (EmailValidator.validate(email)) {
        service.create(request).then((value) {
          if (value != null) {
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
          global.showSnackbar(
              context, 'Terjadi kesalahan saat menambahkan data');
          log('error : $error');
        });
      } else {
        hideLoading();
        global.showSnackbar(context, 'Alamat email tidak valid');
      }
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
                'Tambah personal info',
                style: TextStyle(fontSize: 15),
              ),
              centerTitle: true,
              background: Icon(
                Icons.person,
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
                  decoration: const InputDecoration(
                    icon: Icon(Icons.phone),
                    labelText: 'Nomor Telepon',
                  ),
                  onChanged: (e) => {phoneNumber = e},
                  controller: _controllerPhoneNumber,
                  keyboardType: TextInputType.phone,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.location_city),
                    labelText: 'Alamat',
                  ),
                  onChanged: (e) => {address = e},
                  controller: _controlleraddress,
                  keyboardType: TextInputType.streetAddress,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.email),
                    labelText: 'Email',
                  ),
                  onChanged: (e) => {email = e},
                  controller: _controllerEmail,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.link),
                    labelText: 'Website',
                  ),
                  onChanged: (e) => {website = e},
                  controller: _controllerWebsite,
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(
                  height: 30.0,
                ),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.grey[800],
                        minimumSize: const Size.fromHeight(50),
                        elevation: 0),
                    onPressed: _isLoading
                        ? null
                        : () {
                            addData();
                          },
                    icon: _isLoading
                        ? Container(
                            width: 16,
                            height: 16,
                            margin: const EdgeInsets.only(right: 30),
                            child: CircularProgressIndicator(
                              color: Colors.grey[800],
                            ))
                        : const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                    label: _isLoading
                        ? const Text(
                            'Sedang menambahkan data...',
                            style: TextStyle(color: Colors.white),
                          )
                        : const Text(
                            'Tambah',
                            style: TextStyle(color: Colors.white),
                          ))
              ],
            ),
          ))
        ],
      ),
    );
  }
}
