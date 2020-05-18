import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:starter_architecture_flutter_firebase/app/home/models/banana.dart';
import 'package:starter_architecture_flutter_firebase/common_widgets/show_alert_dialog.dart';
import 'package:starter_architecture_flutter_firebase/common_widgets/show_exception_alert_dialog.dart';
import 'package:starter_architecture_flutter_firebase/routing/router.dart';
import 'package:starter_architecture_flutter_firebase/services/firestore_database.dart';

class EditBananaPage extends StatefulWidget {
  const EditBananaPage({Key key, this.banana}) : super(key: key);
  final Banana banana;

  static Future<void> show(BuildContext context, {Banana banana}) async {
    await Navigator.of(context, rootNavigator: true).pushNamed(
      Routes.editBananaPage,
      arguments: banana,
    );
  }

  @override
  _EditBananaPageState createState() => _EditBananaPageState();
}

class _EditBananaPageState extends State<EditBananaPage> {
  final _formKey = GlobalKey<FormState>();

  String _name;
  int _ratePerHour;
  String _description;

  @override
  void initState() {
    super.initState();
    if (widget.banana != null) {
      _name = widget.banana.name;
      _ratePerHour = widget.banana.ratePerHour;
      _description = widget.banana.description;
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
        final bananas = await database.bananasStream().first;
        final allLowerCaseNames =
            bananas.map((banana) => banana.name.toLowerCase()).toList();
        if (widget.banana != null) {
          allLowerCaseNames.remove(widget.banana.name.toLowerCase());
        }
        if (allLowerCaseNames.contains(_name.toLowerCase())) {
          showAlertDialog(
            context: context,
            title: 'Name already used',
            content: 'Please choose a different banana name',
            defaultActionText: 'OK',
          );
        } else {
          final id = widget.banana?.id ?? documentIdFromCurrentDate();
          final banana = Banana(id: id, name: _name, ratePerHour: _ratePerHour, description: _description);
          await database.setBanana(banana);
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
        title: Text(widget.banana == null ? 'New Banana' : 'Edit Banana'),
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
        decoration: InputDecoration(labelText: 'Banana name'),
        keyboardAppearance: Brightness.light,
        initialValue: _name,
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Banana description'),
        keyboardAppearance: Brightness.light,
        initialValue: _description,
        validator: (value) => value.isNotEmpty ? null : 'Description can\'t be empty',
        onSaved: (value) => _description = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Rate per hour'),
        keyboardAppearance: Brightness.light,
        initialValue: _ratePerHour != null ? '$_ratePerHour' : null,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _ratePerHour = int.tryParse(value) ?? 0,
      ),
    ];
  }
}
