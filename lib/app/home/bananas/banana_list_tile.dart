
import 'package:flutter/material.dart';
import 'package:starter_architecture_flutter_firebase/app/home/models/banana.dart';

class BananaListTile extends StatelessWidget {
  const BananaListTile({Key key, @required this.banana, this.onTap}) : super(key: key);
  final Banana banana;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(banana.name),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
