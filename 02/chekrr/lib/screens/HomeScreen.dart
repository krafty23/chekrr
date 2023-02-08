import 'package:chekrr/screens/add_task.dart';
import "package:flutter/material.dart";
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mysql1/mysql1.dart';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import '../globals.dart' as globals;
import '../controllers/TaskController.dart';
import 'package:chekrr/drawer.dart';
import 'package:http/http.dart' as http;
import '../models/task.dart';
import '../bottomtab.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
//class HomeScreen extends StatelessWidget {

  late Future<List<Task>> _future;
  Future<List<Task>> getTask() async {
    final box = GetStorage();
    var uid = box.read('uid');
    try {
      Map<String, dynamic> requestbody = {
        //'uid': globals.uid.toString(),
        'uid': uid.toString(),
      };
      http.Response response = await http.post(
          Uri.parse(globals.globalProtocol +
              globals.globalURL +
              '/api/index.php/task/list'),
          headers: <String, String>{
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
            //'Content-Type': 'application/json; charset=UTF-8',
          },
          body: requestbody);
      if (response.statusCode == 200) {
        return TaskFromJson(response.body);
      } else {
        return <Task>[];
      }
    } catch (e) {
      return <Task>[]; // return an empty list on exception/error
    }
  }

  Offset _tapPosition = Offset.zero;
  void _getTapPosition(LongPressStartDetails details) {
    final RenderBox referenceBox = context.findRenderObject() as RenderBox;
    setState(() {
      _tapPosition = referenceBox.globalToLocal(details.globalPosition);
    });
  }

  _showPopupMenu(BuildContext context) async {
    //double left = offset.dx;
    //double top = offset.dy;
    /*final RenderObject? overlay =
        Overlay.of(context).context.findRenderObject();
    await showMenu(
      context: context,
      color: Color.fromRGBO(15, 5, 31, 0.835),
      //position: RelativeRect.fromLTRB(0, 0, 0, 0),
      position: RelativeRect.fromRect(
          Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 30, 30),
          Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
              overlay.paintBounds.size.height)),
      //position: RelativeRect.fromLTRB(left, top, 0, 0),
      items: [
        PopupMenuItem<String>(
            child: ElevatedButton.icon(
              icon: Icon(
                // <-- Icon
                Icons.delete,
                size: 25.0,
              ),
              label: Text('Přijmout výzvy'),
              onPressed: () {},
            ),
            value: 'Doge'),
        PopupMenuItem<String>(child: Text('Lion'), value: 'Lion'),
      ],
      elevation: 8.0,
    );*/
    return AlertDialog(
        contentPadding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        content: Text('dfdff'));
  }

  Future<void> _dialogConfirmer(BuildContext context, Task data) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(213, 131, 1, 1),
          title: data.folder_id > 0
              ? Text(
                  'Opravdu zrušit program?',
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.692),
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                )
              : Text(
                  'Opravdu zrušit výzvu?',
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.692),
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: data.folder_id > 0
                    ? Text(
                        'Opravdu si přejete zrušit program "' +
                            data.folder_name.toString() +
                            '" včetně všech výzev?',
                        style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 0.459),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : Text(
                        'Opravdu si přejete zrušit výzvu "' +
                            data.name.toString() +
                            '" včetně všech možných opakování?',
                        style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 0.459),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              )
            ],
          ),
          actions: <Widget>[
            data.folder_id > 0
                ? ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 214, 214, 214)),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 255, 0, 0)),
                    ),
                    child: const Text('Ano'),
                    onPressed: () {
                      HapticFeedback.heavyImpact();
                      DeleteProgram(data.id.toString())
                          .then((value) => setState(() {
                                _future = getTask();
                              }));
                      Navigator.of(context).pop();
                      Get.showSnackbar(
                        GetSnackBar(
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Color.fromARGB(200, 0, 0, 0),
                          title: 'Program zrušen',
                          message: data.folder_name,
                          icon: const Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  )
                : ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 214, 214, 214)),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 255, 0, 0)),
                    ),
                    child: const Text('Ano'),
                    onPressed: () {
                      HapticFeedback.heavyImpact();
                      DeleteTask(data.id.toString())
                          .then((value) => setState(() {
                                _future = getTask();
                              }));
                      Navigator.of(context).pop();
                      Get.showSnackbar(
                        GetSnackBar(
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Color.fromARGB(200, 0, 0, 0),
                          title: 'Výzva zrušena',
                          message: data.name,
                          icon: const Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
            ElevatedButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 255, 255, 255)),
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(126, 0, 0, 0)),
              ),
              child: const Text('Ne'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _dialogBuilder(BuildContext context, Task data) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            data.name,
            style: TextStyle(
              color: Color.fromRGBO(255, 255, 255, 0.692),
              fontSize: 22,
              fontWeight: FontWeight.w400,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              data.folder_id > 0
                  ? Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Text(
                        'Součást programu ' + data.folder_name.toString(),
                        style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 0.459),
                          fontSize: 14,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                    )
                  : Container(),
              data.text != ''
                  ? Html(
                      data: data.text,
                    )
                  : Container(),
            ],
          ),
          /*shape: RoundedRectangleBorder(
            side: BorderSide(color: Color.fromARGB(153, 32, 23, 46)),
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),*/
          backgroundColor: Color.fromARGB(218, 22, 19, 29),
          actions: <Widget>[
            data.folder_id > 0
                ? TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                      foregroundColor: Color.fromARGB(255, 255, 0, 0),
                    ),
                    child: const Text('Zrušit program'),
                    onPressed: () {
                      HapticFeedback.heavyImpact();
                      Navigator.of(context).pop();
                      _dialogConfirmer(context, data);
                    },
                  )
                : TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                      foregroundColor: Color.fromARGB(255, 255, 0, 0),
                    ),
                    child: const Text('Zrušit výzvu'),
                    onPressed: () {
                      HapticFeedback.heavyImpact();
                      Navigator.of(context).pop();
                      _dialogConfirmer(context, data);
                      //DeleteTask(data.id.toString());
                      /*setState(() {
                        _future = getTask();
                      });*/
                    },
                  ),
          ],
        );
      },
    );
  }

  late GlobalKey<ScaffoldState> _scaffoldKey;
  @override
  void initState() {
    _scaffoldKey = GlobalKey();
    super.initState();
    _future = getTask();
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
      ),
    );
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    //  overlays: [SystemUiOverlay.top]);
  }

  /*void reassemble() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
      ),
    );
  }*/

  @override
  /*void reassemble() {
    super.initState();
    _future = getTask();
    _scaffoldKey = GlobalKey();
    super.reassemble();
  }*/

  Widget build(BuildContext context) {
    //final TaskController taskController = Get.put(TaskController());

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        title: Text("Můj Plán Dne"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(230, 57, 21, 119),
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          Get.toNamed('/add_task')?.then((result) {
            _future = getTask();
          });
          ;
        },
      ),
      drawer: DrawerDraw(),
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 100, 0, 80),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/chekrr_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder(
          future: _future,
          builder: (context, AsyncSnapshot<List<Task>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Text('none');
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              case ConnectionState.active:
                return Text('');
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Text(
                    '${snapshot.error}',
                    style: TextStyle(color: Colors.red),
                  );
                } else {
                  return Column(
                    children: <Widget>[
                      Expanded(
                        child: snapshot.data!.isNotEmpty
                            ? ListView.builder(
                                padding: EdgeInsets.zero,
                                key: _scaffoldKey,
                                //separatorBuilder: (_, __) => Divider(),
                                //itemCount: taskController.tasks.length,
                                itemCount: snapshot.data?.length,
                                itemBuilder: (context, index) => Dismissible(
                                  confirmDismiss: (direction) async {
                                    bool delete = true;
                                    if (direction ==
                                        DismissDirection.startToEnd) {
                                      /*setState(() {
                    flavors[index] =
                        flavor.copyWith(isFavorite: !flavor.isFavorite);
                  });*/
                                      FinishTask(
                                          snapshot.data![index].id.toString());
                                      Get.showSnackbar(
                                        GetSnackBar(
                                          snackPosition: SnackPosition.TOP,
                                          backgroundColor:
                                              Color.fromARGB(220, 0, 0, 0),
                                          title: 'Gratulace!',
                                          message: 'Výzva ' +
                                              snapshot.data![index].name +
                                              ' splněna',
                                          icon: const Icon(
                                            Icons.check,
                                            color: Colors.green,
                                          ),
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                      return delete;
                                    } else {
                                      bool delete = true;
                                      RejectTask(
                                          snapshot.data![index].id.toString());
                                      Get.showSnackbar(
                                        GetSnackBar(
                                          snackPosition: SnackPosition.TOP,
                                          backgroundColor:
                                              Color.fromARGB(220, 0, 0, 0),
                                          title: 'Příště to vyjde!',
                                          message: 'Výzva ' +
                                              snapshot.data![index].name +
                                              ' nesplněna',
                                          icon: const Icon(
                                            Icons.close,
                                            color: Colors.red,
                                          ),
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                      return delete;
                                    }
                                  },
                                  onDismissed: (_) {
                                    /*Get.showSnackbar(
                          GetSnackBar(
                            title: 'Hovno!',
                            message: 'Ser na to',
                            icon: const Icon(
                              Icons.percent,
                              color: Colors.green,
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );*/
                                  },
                                  background: Container(
                                    color: Color.fromARGB(100, 76, 175, 79),
                                    child: Align(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16),
                                        child: Icon(Icons.check),
                                      ),
                                      alignment: Alignment.centerLeft,
                                    ),
                                  ),
                                  secondaryBackground: Container(
                                    color: Color.fromARGB(100, 244, 67, 54),
                                    child: Align(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 16),
                                        child: Icon(Icons.close),
                                      ),
                                      alignment: Alignment.centerRight,
                                    ),
                                  ),
                                  key: UniqueKey(),
                                  child: GestureDetector(
                                    onLongPressStart: (details) =>
                                        HapticFeedback.heavyImpact(),
                                    //onLongPress: () => _showPopupMenu(context),
                                    onLongPress: () => _dialogBuilder(
                                        context, snapshot.data![index]),
                                    child: Container(
                                      margin: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(129, 0, 0, 0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                      ),
                                      child: ListTile(
                                        visualDensity:
                                            VisualDensity(vertical: 3),
                                        title: Text(
                                          //taskController.tasks[index].name,
                                          snapshot.data![index].name,
                                          style: TextStyle(
                                            color: Color.fromRGBO(
                                                255, 255, 255, 0.801),
                                          ),
                                        ),
                                        //onTap: () {
                                        /*Get.to(AddTaskScreen(
                    index: index,
                  ));*/
                                        //},
                                        /*onLongPress: () {
                                        Get.showSnackbar(
                                          GetSnackBar(
                                            title: 'Klik!',
                                            message: 'jde to',
                                            icon: const Icon(
                                              Icons.cancel,
                                              color: Colors.blueGrey,
                                            ),
                                            duration:
                                                const Duration(seconds: 2),
                                          ),
                                        );
                                      },*/
                                        leading: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.close,
                                              color: Colors.red,
                                            ),
                                          ],
                                        ),
                                        trailing: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.check,
                                              //Icons.chevron_right,
                                              color: Colors.green,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Column(
                                children: <Widget>[
                                  Expanded(
                                    child: Center(
                                      child: Text('Žádné výzvy nenalezeny'),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  );
                }
            }
          },
        ),
      ),
      bottomNavigationBar: BottomTabs(),
    );
  }
}

Future<http.Response> FinishTask(var id) async {
  //var conn = await MySqlConnection.connect(globals.dbSettings);
  final task = TaskId(id);
  Map<String, dynamic> body = {
    'id': id.toString(),
  };
  final response =
      await http.post(Uri.parse('https://chekrr.cz/api/finish_task.php'),
          headers: <String, String>{
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
            //'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body);
  if (response.statusCode == 200) {
    //print(response.body);
  } else {
    throw Exception('Chyba: nepodařilo se označit výzvu jako dokončenou - ' +
        response.body +
        ' / ' +
        response.statusCode.toString());
  }
  return response;
}

Future<http.Response> RejectTask(var id) async {
  //var conn = await MySqlConnection.connect(globals.dbSettings);
  final task = TaskId(id);
  Map<String, dynamic> body = {
    'id': id.toString(),
  };
  final response =
      await http.post(Uri.parse('https://chekrr.cz/api/reject_task.php'),
          headers: <String, String>{
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
            //'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body);
  if (response.statusCode == 200) {
    //print(response.body);
  } else {
    throw Exception('Chyba: nepodařilo se označit výzvu jako zrušenou - ' +
        response.body +
        ' / ' +
        response.statusCode.toString());
  }
  return response;
}

Future<http.Response> DeleteTask(var id) async {
  final task = TaskId(id);
  Map<String, dynamic> body = {
    'id': id.toString(),
  };
  final response =
      await http.post(Uri.parse('https://chekrr.cz/api/delete_task.php'),
          headers: <String, String>{
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
            //'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body);
  if (response.statusCode == 200) {
    //print(response.body);
  } else {
    throw Exception('Chyba: nepodařilo se označit výzvu jako zrušenou - ' +
        response.body +
        ' / ' +
        response.statusCode.toString());
  }
  return response;
}

Future<http.Response> DeleteProgram(var id) async {
  final task = TaskId(id);
  Map<String, dynamic> body = {
    'id': id.toString(),
  };
  final response =
      await http.post(Uri.parse('https://chekrr.cz/api/delete_program.php'),
          headers: <String, String>{
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
            //'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body);
  if (response.statusCode == 200) {
    //print(response.body);
  } else {
    throw Exception('Chyba: nepodařilo se označit výzvu jako zrušenou - ' +
        response.body +
        ' / ' +
        response.statusCode.toString());
  }
  return response;
}
