import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:starter_architecture_flutter_firebase/app/home/models/account.dart';
import 'package:starter_architecture_flutter_firebase/common_widgets/show_alert_dialog.dart';
import 'package:starter_architecture_flutter_firebase/common_widgets/show_exception_alert_dialog.dart';
import 'package:starter_architecture_flutter_firebase/routing/router.dart';
import 'package:starter_architecture_flutter_firebase/services/firestore_database.dart';

class EditAccountPage extends StatefulWidget {
  const EditAccountPage({Key key, this.account}) : super(key: key);
  final Account account;

  static Future<void> show(BuildContext context, {Account account}) async {
    await Navigator.of(context, rootNavigator: true).pushNamed(
      Routes.editAccountPage,
      arguments: account,
    );
  }

  @override
  _EditAccountPageState createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  final _formKey = GlobalKey<FormState>();

  String _displayName;
  String _photoUrl;
  String _bio;

  @override
  void initState() {
    super.initState();
    if (widget.account != null) {
      _displayName = widget.account.displayName;
      _photoUrl = widget.account.photoUrl;
      _bio = widget.account.bio;
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final database = Provider.of<FirestoreDatabase>(context, listen: false);
        final accounts = await database.accountsStream().first;
        final allLowerCaseNames =
            accounts.map((account) => account.displayName.toLowerCase()).toList();
        if (widget.account != null) {
          allLowerCaseNames.remove(widget.account.displayName.toLowerCase());
        }
        if (allLowerCaseNames.contains(_displayName.toLowerCase())) {
          showAlertDialog(
            context: context,
            title: 'Name already used',
            content: 'Please choose a different account name',
            defaultActionText: 'OK',
          );
        } else {
          final id = widget.account?.id ?? documentIdFromCurrentDate();
          final account = Account(id: id, displayName: _displayName, photoUrl: _photoUrl, bio: _bio);
          await database.setAccount(account);
          Navigator.of(context).pop();
        }
      } catch (e) {
        showExceptionAlertDialog(
          context: context,
          title: 'Operation failed',
          exception: e,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.account == null ? 'New Account' : 'Edit Account'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Save',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: _submit,
          ),
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Account name'),
        keyboardAppearance: Brightness.light,
        initialValue: _displayName,
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _displayName = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Account bio'),
        keyboardAppearance: Brightness.light,
        initialValue: _bio,
        // validator: (value) => value.isNotEmpty ? null : 'Bio can\'t be empty',
        onSaved: (value) => _bio = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'PhotoUrl'),
        keyboardAppearance: Brightness.light,
        initialValue: _photoUrl != null ? '$_photoUrl' : null,
        onSaved: (value) => _photoUrl = value,
      ),
    ];
  }
}
