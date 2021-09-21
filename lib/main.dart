import 'package:flutter/material.dart';
import 'package:numbers/pages/numbers/ContactHelper/ContactHelper.dart';
import 'package:numbers/pages/numbers/ContactHelper/ContactDBProcess.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:numbers/pages/numbers/Search.dart';
import 'package:numbers/pages/numbers/Info.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:clipboard_manager/clipboard_manager.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      title: 'Numbers',
      home: Numbers2(),
    );
  }
}

class Numbers2 extends StatefulWidget {
  _Numbers2PageState createState() => _Numbers2PageState();
}

class _Numbers2PageState extends State<Numbers2> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  //======================*
  var contactDBProcess;
  TextEditingController newContactName = TextEditingController();
  TextEditingController newContactNumber = TextEditingController();
  TextEditingController contactName = TextEditingController();
  TextEditingController contactNumber = TextEditingController();

  Future<List<ContactHelper>> getContactList;
  TextEditingController msgTextController = TextEditingController();
  String name;
  String number;
  initState() {
    super.initState();
    print('ashabb - database - init');
    contactDBProcess = ContactDBProcess();
    getContactList = contactDBProcess.getContactListTable();
  }

  clearName() {
    msgTextController.text = '';
  }

  saveContact() {
    ContactHelper data =
        ContactHelper(null, contactName.text, contactNumber.text);
    contactDBProcess.saveContactListTable(data);
    refreshList();
  }

  updateContact(id) {
    ContactHelper data2 =
        ContactHelper(id, newContactName.text, newContactNumber.text);
    contactDBProcess.update(data2);
    refreshList();
  }

  deleteContact(contactId) {
    contactDBProcess.delete(contactId);
    refreshList();
  }

  refreshList() {
    setState(() {
      getContactList = contactDBProcess.getContactListTable();
    });
  }

//--
  void showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Container(
                height: 270,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Text('Add Number',
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.w700)),
                      TextField(
                          controller: contactName,
                          decoration: InputDecoration(
                            labelText: "Name",
                          )),
                      TextField(
                          keyboardType: TextInputType.number,
                          controller: contactNumber,
                          decoration: InputDecoration(
                            labelText: "Number",
                          )),
                      FlatButton(
                        child: const Text('Reset',
                            style: TextStyle(color: Colors.black)),
                        padding: new EdgeInsets.all(10.0),
                        splashColor: Colors.blueGrey,
                        onPressed: () => setState(() {
                          contactName.text = '';
                          contactNumber.text = '';
                        }),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          FlatButton(
                            child: const Text('Cancel',
                                style: TextStyle(color: Colors.red)),
                            padding: new EdgeInsets.all(10.0),
                            splashColor: Colors.blueGrey,
                            onPressed: () => setState(() {
                              Navigator.pop(context);
                              contactName.text = '';
                              contactNumber.text = '';
                            }),
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding: new EdgeInsets.all(10.0),
                            child: new FlatButton(
                              child: const Text('submit',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white)),
                              color: Theme.of(context).accentColor,
                              padding: new EdgeInsets.all(10.0),
                              splashColor: Colors.blueGrey,
                              onPressed: saveContact,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

  //--
  void editAlert(BuildContext context, id, oldName, oldNnumber) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Container(
                height: 270,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Text('Edit Number',
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.w700)),
                      TextField(
                        controller: newContactName =
                            TextEditingController(text: oldName),
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
                        controller: newContactNumber =
                            TextEditingController(text: oldNnumber),
                      ),
                      FlatButton(
                        child: const Text('Reset',
                            style: TextStyle(color: Colors.black)),
                        padding: new EdgeInsets.all(10.0),
                        splashColor: Colors.blueGrey,
                        onPressed: () => setState(() {
                          newContactName.text = '';
                          newContactNumber.text = '';
                        }),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          FlatButton(
                            child: const Text('Cancel',
                                style: TextStyle(color: Colors.red)),
                            padding: new EdgeInsets.all(10.0),
                            splashColor: Colors.blueGrey,
                            onPressed: () => setState(() {
                              Navigator.pop(context);
                              newContactName.text = '';
                              newContactNumber.text = '';
                            }),
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding: new EdgeInsets.all(10.0),
                            child: new FlatButton(
                              child: const Text('Update',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white)),
                              color: Theme.of(context).accentColor,
                              padding: new EdgeInsets.all(10.0),
                              splashColor: Colors.blueGrey,
                              onPressed: () {
                                updateContact(id);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

  //======================^

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        title: Text('Numbers', style: TextStyle(color: Colors.black)),
        leading: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Info(),
            ),
          ),
          child: Container(
            color: Colors.transparent,
            margin: const EdgeInsets.all(9),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage(
                'assets/icons/numbers.png',
              ),
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            tooltip: 'Seacrh Contact',
            onPressed: () => refreshList(),
            icon: Icon(Icons.refresh),
            color: Colors.black,
          ),
          IconButton(
            tooltip: 'Seacrh Contact',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Search(),
              ),
            ),
            icon: Icon(Icons.search),
            color: Colors.black,
          ),
        ],
      ),
      body: new Container(
        height: MediaQuery.of(context).size.height,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            list(
              getContactList,
              context,
              _scaffoldKey,
              editAlert,
              deleteContact,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("add"),
        icon: Icon(Icons.add),
        onPressed: () => showAlert(context),
      ),
      backgroundColor: Colors.white,
    );
  }
}

//--
list(
  getContactList,
  context,
  _scaffoldKey,
  editAlert,
  deleteContact,
) {
  return Expanded(
    child: FutureBuilder(
      future: getContactList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return contactList(
            snapshot.data,
            context,
            _scaffoldKey,
            editAlert,
            deleteContact,
          );
        }
        if (null == snapshot.data || snapshot.data.length == 0) {
          return Center(child: Text("Add Nmbers"));
        }
        return CircularProgressIndicator();
      },
    ),
  );
}

Widget contactList(
  List<ContactHelper> getContactList,
  context,
  _scaffoldKey,
  editAlert,
  deleteContact,
) {
  return ListView.builder(
      itemCount: getContactList.length,
      itemBuilder: (BuildContext ctxt, int index) {
        // return  Text(getContactList[index].name);
        return ListTile(
          leading: new CircleAvatar(
            child: Text(
              getContactList[index].name.substring(0, 1).toUpperCase(),
              style: TextStyle(color: Colors.white, fontSize: 35),
            ),
            radius: 30.0,
            backgroundColor: Colors.blue,
          ),
          title: Text(
            getContactList[index].name,
            style:
                new TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          subtitle: Text(
            getContactList[index].numbers,
            style: new TextStyle(color: Colors.grey, fontSize: 15.0),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                tooltip: 'Call',
                onPressed: () =>
                    UrlLauncher.launch("tel:" + getContactList[index].numbers),
                icon: Icon(Icons.call),
                color: Colors.green,
              ),
              IconButton(
                tooltip: 'Call',
                onPressed: () =>
                    UrlLauncher.launch("sms:" + getContactList[index].numbers),
                icon: Icon(Icons.sms),
                color: Colors.blue,
              ),
              PopupMenuButton(
                  onSelected: (choice) => choiceAction(
                        choice,
                        context,
                        _scaffoldKey,
                        getContactList[index].id,
                        getContactList[index].name,
                        getContactList[index].numbers,
                        editAlert,
                        deleteContact,
                      ),
                  itemBuilder: (BuildContext context) {
                    return Constants.choices.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  })
            ],
          ),
        );
      });
}
//--

void choiceAction(String choice, BuildContext context, _scaffoldKey, deleteID,
    name, number, editAlert, deleteContact) {
  switch (choice) {
    case 'Copy':
      ClipboardManager.copyToClipBoard(
              'Name : ' + name + ' , Number : ' + number)
          .then(
        (result) {
          showInSnackBarCode(_scaffoldKey, 'Number Copied to Clipboard');
        },
      );

      return print('Copy');
      break;
    case 'Edit':
      editAlert(context, deleteID, name, number);
      return print('Edit');
      break;
    case 'Delete':
      deleteContact(deleteID);
      return print('Delete');
      break;
    default:
      return print("Default");
  }
}

class Constants {
  static const String c1 = "Copy";
  static const String c2 = "Edit";
  static const String c3 = "Delete";

  static const List<String> choices = <String>[c1, c2, c3];
}

//--^
void showInSnackBarCode(_scaffoldKey, String value) {
  _scaffoldKey.currentState.showSnackBar(new SnackBar(
    content: Row(
      children: <Widget>[
        Icon(Icons.done),
        Text(value),
      ],
    ),
  ));
}
