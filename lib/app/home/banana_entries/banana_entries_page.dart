import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:starter_architecture_flutter_firebase/app/home/banana_entries/entry_list_item.dart';
import 'package:starter_architecture_flutter_firebase/app/home/banana_entries/entry_page.dart';
import 'package:starter_architecture_flutter_firebase/app/home/bananas/edit_banana_page.dart';
import 'package:starter_architecture_flutter_firebase/app/home/bananas/list_items_builder.dart';
import 'package:starter_architecture_flutter_firebase/app/home/models/entry.dart';
import 'package:starter_architecture_flutter_firebase/app/home/models/banana.dart';
import 'package:starter_architecture_flutter_firebase/common_widgets/show_exception_alert_dialog.dart';
import 'package:starter_architecture_flutter_firebase/routing/cupertino_tab_view_router.dart';
import 'package:starter_architecture_flutter_firebase/services/firestore_database.dart';

class BananaEntriesPage extends StatelessWidget {
  const BananaEntriesPage({@required this.banana});
  final Banana banana;

  static Future<void> show(BuildContext context, Banana banana) async {
    await Navigator.of(context).pushNamed(
      CupertinoTabViewRoutes.bananaEntriesPage,
      arguments: banana,
    );
  }

  Future<void> _deleteEntry(BuildContext context, Entry entry) async {
    try {
      final database = Provider.of<FirestoreDatabase>(context, listen: false);
      await database.deleteEntry(entry);
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
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    return StreamBuilder<Banana>(
      stream: database.bananaStream(bananaId: banana.id),
      builder: (context, snapshot) {
        final banana = snapshot.data;
        final bananaName = banana?.name ?? '';
        return Scaffold(
          appBar: AppBar(
            elevation: 2.0,
            title: Text(bananaName),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.edit, color: Colors.white),
                onPressed: () => EditBananaPage.show(
                  context,
                  banana: banana,
                ),
              ),
              IconButton(
                icon: Icon(Icons.add, color: Colors.white),
                onPressed: () => EntryPage.show(
                  context: context,
                  banana: banana,
                ),
              ),
            ],
          ),
          body: _buildContent(context, banana),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, Banana banana) {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    return StreamBuilder<List<Entry>>(
      stream: database.entriesStream(banana: banana),
      builder: (context, snapshot) {
        return ListItemsBuilder<Entry>(
          snapshot: snapshot,
          itemBuilder: (context, entry) {
            return DismissibleEntryListItem(
              key: Key('entry-${entry.id}'),
              entry: entry,
              banana: banana,
              onDismissed: () => _deleteEntry(context, entry),
              onTap: () => EntryPage.show(
                context: context,
                banana: banana,
                entry: entry,
              ),
            );
          },
        );
      },
    );
  }
}
