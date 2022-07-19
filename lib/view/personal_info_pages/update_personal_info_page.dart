// ignore_for_file: must_be_immutable, no_logic_in_create_state, non_constant_identifier_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:password_manager/api/personal_info/personal_info_req_res.dart';
import 'package:password_manager/api/personal_info/personal_info_service.dart';
import 'package:password_manager/model/personal_info_model.dart';
import 'package:password_manager/view/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:password_manager/utils/helper.dart' as global;

class UpdatePersonalInfoPage extends StatefulWidget {
  UpdatePersonalInfoPage({Key? key, required this.data}) : super(key: key);

  PersonalInfo data;

  @override
  State<UpdatePersonalInfoPage> createState() =>
      _UpdatePersonalInfoPageState(data);
}

class _UpdatePersonalInfoPageState extends State<UpdatePersonalInfoPage> {
  PersonalInfo? data;
  _UpdatePersonalInfoPageState(this.data);

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
  void initState() {
    super.initState();
    _controlleraddress.text = data!.piAddress;
    _controllerPhoneNumber.text = data!.piPhoneNumber;
    _controllerWebsite.text = data!.piWebsite;
    _controllerEmail.text = data!.piEmail;

    address = data!.piAddress;
    phoneNumber = data!.piPhoneNumber;
    website = data!.piWebsite;
    email = data!.piEmail;
  }

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

  updateData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userId') ?? false;
    if (userId != '') {
      update(userId);
    }
  }

  void update(userId) async {
    UpdatePersonalInfoRequest request = UpdatePersonalInfoRequest(
        piAddress: address,
        piPhoneNumber: phoneNumber,
        piWebsite: website,
        piEmail: email,
        userId: userId);
    if (address != '' && phoneNumber != '' && website != '' && email != '') {
      showLoading();
      service.update(request, data!.id).then((value) {
        if (value != null) {
          hideLoading();
          global.showSnackbar(context, 'Data berhasil di update');
          Future.delayed(const Duration(milliseconds: 3000), () {
            setState(() {
              global.customPushRemoveNavigator(context, const HomePage());
            });
          });
        } else {
          hideLoading();
          log('value ${value!.data}');
          global.showSnackbar(context, 'Gagal mengubah data');
        }
      }).onError((error, stackTrace) {
        hideLoading();
        global.showSnackbar(context, 'Terjadi kesalahan saat menambahkan data');
        log('error : $error');
      });
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
                'Ubah personal info',
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
                            updateData();
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
                            Icons.save,
                            color: Colors.white,
                          ),
                    label: _isLoading
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
          ))
        ],
      ),
    );
  }
}
