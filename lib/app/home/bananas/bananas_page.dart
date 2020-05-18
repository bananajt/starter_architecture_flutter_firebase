import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:starter_architecture_flutter_firebase/app/home/banana_entries/banana_entries_page.dart';
import 'package:starter_architecture_flutter_firebase/app/home/bananas/edit_banana_page.dart';
import 'package:starter_architecture_flutter_firebase/app/home/bananas/banana_list_tile.dart';
import 'package:starter_architecture_flutter_firebase/app/home/bananas/list_items_builder.dart';
import 'package:starter_architecture_flutter_firebase/app/home/models/banana.dart';
import 'package:starter_architecture_flutter_firebase/common_widgets/show_exception_alert_dialog.dart';
import 'package:starter_architecture_flutter_firebase/constants/strings.dart';
import 'package:starter_architecture_flutter_firebase/services/firestore_database.dart';

class BananasPage extends StatelessWidget {
  Future<void> _delete(BuildContext context, Banana banana) async {
    try {
      final database = Provider.of<FirestoreDatabase>(context, listen: false);
      await database.deleteBanana(banana);
    } catch (e) {
      showExceptionAlertDialog(
        context: context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.bananas),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () => EditBananaPage.show(context),
          ),
        ],
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    return StreamBuilder<List<Banana>>(
      stream: database.bananasStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<Banana>(
          snapshot: snapshot,
          itemBuilder: (context, banana) => Dismissible(
            key: Key('banana-${banana.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, banana),
            child: BananaListTile(
              banana: banana,
              onTap: () => BananaEntriesPage.show(context, banana),
            ),
          ),
        );
      },
    );
  }
}
