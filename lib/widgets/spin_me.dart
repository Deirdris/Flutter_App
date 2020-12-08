import 'package:flutter/material.dart';

class SpinMe extends StatelessWidget {
  SpinMe({this.isSaving = false});

  final bool isSaving;

  @override
  Widget build(BuildContext context) {
    return isSaving ? Center(child: Container(
      width: 14,
      height: 14,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation(Colors.white),
      ),
    )) : Text(
      'Zapisz',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
    );
  }
}
