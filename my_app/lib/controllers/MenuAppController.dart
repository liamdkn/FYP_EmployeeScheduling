import 'package:flutter/material.dart';

class MenuAppController extends ChangeNotifier {
  GlobalKey<ScaffoldState>? _scaffoldKey;

  void setScaffoldKey(GlobalKey<ScaffoldState> key) {
    _scaffoldKey = key;
  }

  void controlMenu() {
    try {
      if (_scaffoldKey != null && !_scaffoldKey!.currentState!.isDrawerOpen) {
        _scaffoldKey!.currentState!.openDrawer();
      }
    } catch (e, stackTrace) {
      print("An error occurred in MenuAppController:");
      print(e);
      print(stackTrace);
    }
  }
}
