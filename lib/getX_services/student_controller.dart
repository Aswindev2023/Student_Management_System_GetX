import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:students_getx/model/user.dart';

class StudentController extends GetxController {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _contactController = TextEditingController();
  final _batchController = TextEditingController();

  TextEditingController get nameController => _nameController;
  TextEditingController get addressController => _addressController;
  TextEditingController get contactController => _contactController;
  TextEditingController get batchController => _batchController;
  GlobalKey<FormState> get formKey => _formKey;

  void clearText() {
    _nameController.clear();
    _addressController.clear();
    _contactController.clear();
    _batchController.clear();
  }

  void setInitialValues(User user) {
    _nameController.text = user.name ?? '';
    _addressController.text = user.address ?? '';
    _contactController.text = user.contact ?? '';
    _batchController.text = user.batch ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    _batchController.dispose();
    super.dispose();
  }
}
