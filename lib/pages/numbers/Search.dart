import 'package:flutter/material.dart';
import 'package:numbers/pages/numbers/ContactHelper/ContactHelper.dart';
import 'package:numbers/pages/numbers/ContactHelper/ContactDBProcess.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class Search extends StatefulWidget {
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<Search> {
  //--
  var contactDBProcess;
  Future<List<ContactHelper>> getContactList;
  TextEditingController searchNameNumber = TextEditingController();
  initState() {
    super.initState();
    print('ashabb - database - init');
    contactDBProcess = ContactDBProcess();
    getContactList = contactDBProcess.getContactListTable();
  }

  /*searchContact(nameNumber) {
    getContactList = contactDBProcess.getContactListTableOnly(nameNumber);
    //refreshList(nameNumber);
  }*/

  onClickRefreshList(nameNumber) {
    setState(() {
      getContactList = contactDBProcess.getContactListTableOnly(nameNumber);
    });
  }

  //--^
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          title: Text('Search', style: TextStyle(color: Colors.black)),
          leading: IconButton(
            tooltip: 'Back',
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.black,
          ),
        ),
        body: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(10),
              padding: new EdgeInsets.all(2),
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(100),
                color: Colors.black26,
              ),
              width: double.infinity,
              child: TextFormField(
                style: TextStyle(color: Colors.blue),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(15.0),
                  hintText: 'Search by Name or Number',
                  border: InputBorder.none,
                ),
                onChanged: (string) {
                  onClickRefreshList(string);
                },
              ),
            ),
            Expanded(
              child: Container(
                height: 500.0,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  verticalDirection: VerticalDirection.down,
                  children: <Widget>[
                    list(getContactList),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}

//--
list(getContactList) {
  return Expanded(
    child: FutureBuilder(
      future: getContactList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return contactList(context, snapshot.data);
        }
        if (null == snapshot.data || snapshot.data.length == 0) {
          return Center(child: Text("no Data Found"));
        }
        return CircularProgressIndicator();
      },
    ),
  );
}

Widget contactList(context, List<ContactHelper> getContactList) {
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
            ],
          ),
        );
      });
}
//--
