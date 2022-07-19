// ignore_for_file: prefer_const_constructors_in_immutables, no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:password_manager/model/personal_info_model.dart';
import 'package:password_manager/view/personal_info_pages/update_personal_info_page.dart';

import 'package:password_manager/utils/helper.dart' as global;

class DetailPersonalInfo extends StatefulWidget {
  DetailPersonalInfo({Key? key, required this.data}) : super(key: key);

  final PersonalInfo data;

  @override
  State<DetailPersonalInfo> createState() => _DetailPersonalInfoState(data);
}

class _DetailPersonalInfoState extends State<DetailPersonalInfo> {
  PersonalInfo? data;
  _DetailPersonalInfoState(this.data);
  late final TextEditingController _controllerWebsite = TextEditingController();
  late final TextEditingController _controllerPhoneNumber =
      TextEditingController();
  late final TextEditingController _controllerEmail = TextEditingController();
  late final TextEditingController _controllerAddress = TextEditingController();

  late String website = '';
  late String phoneNumber = '';
  late String email = '';
  late String address = '';

  final bool _pinned = true;
  final bool _snap = false;
  final bool _floating = false;

  @override
  initState() {
    _controllerWebsite.text = data!.piWebsite;
    _controllerPhoneNumber.text = data!.piPhoneNumber;
    _controllerEmail.text = data!.piEmail;
    _controllerAddress.text = data!.piAddress;

    website = data!.piWebsite;
    phoneNumber = data!.piPhoneNumber;
    address = data!.piAddress;
    email = data!.piEmail;
    super.initState();
  }

  @override
  void dispose() {
    _controllerWebsite.dispose();
    _controllerPhoneNumber.dispose();
    _controllerEmail.dispose();
    _controllerAddress.dispose();
    super.dispose();
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
                'Detail Personal Info',
                style: TextStyle(fontSize: 15),
              ),
              background: Icon(
                Icons.person,
                size: 100,
              ),
              centerTitle: true,
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    global.customPushOnlyNavigator(
                        context, UpdatePersonalInfoPage(data: data!));
                  },
                  icon: const Icon(Icons.edit))
            ],
            backgroundColor: Colors.amber[600],
          ),
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: TextEditingController()
                          ..text = data!.piEmail,
                        onChanged: (e) => email = e,
                        decoration:
                            const InputDecoration(labelText: 'Alamat email'),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          global.copyData(context, data!.piEmail, 'Email');
                        },
                        icon: const Icon(Icons.copy))
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: TextEditingController()
                          ..text = data!.piPhoneNumber,
                        onChanged: (e) => phoneNumber = e,
                        decoration:
                            const InputDecoration(labelText: 'No Telepon'),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          global.copyData(
                              context, data!.piPhoneNumber, 'No Telepon');
                        },
                        icon: const Icon(Icons.copy))
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: TextEditingController()
                          ..text = data!.piWebsite,
                        onChanged: (e) => website = e,
                        decoration: const InputDecoration(labelText: 'Website'),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          global.copyData(
                              context, data!.piWebsite, 'Alamat Website');
                        },
                        icon: const Icon(Icons.copy))
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: TextEditingController()
                          ..text = data!.piAddress,
                        onChanged: (e) => address = e,
                        decoration: const InputDecoration(labelText: 'Alamat'),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          global.copyData(context, data!.piAddress, 'Alamat');
                        },
                        icon: const Icon(Icons.copy))
                  ],
                ),
                TextFormField(
                  readOnly: true,
                  controller: TextEditingController()..text = data!.createdAt,
                  decoration: const InputDecoration(
                      border: InputBorder.none, labelText: 'Dibuat'),
                ),
                TextFormField(
                  readOnly: true,
                  controller: TextEditingController()
                    ..text = data!.updatedAt == 'null'
                        ? 'Belum pernah diperbarui'
                        : data!.updatedAt,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Terakhir diperbarui'),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
