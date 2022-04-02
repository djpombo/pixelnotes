import 'package:crud_sqlite_app/database/datbase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:crud_sqlite_app/models/note_model.dart';
import 'package:crud_sqlite_app/database/datbase.dart';
import 'package:intl/intl.dart';
import 'add_note_screen.dart';
//import 'package:sqflite/sqflite.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Note>> _noteList;

  final DateFormat _dateFormatter = DateFormat('dd/MM/yyyy');

  DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _updateNoteList();
  }

  _updateNoteList() {
    _noteList = _databaseHelper.getNoteList();
  }

  Widget _buildNote(Note note) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(children: [
          ListTile(
            title: Text(
              note.titulo!,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
                decoration: note.status == 0
                    ? TextDecoration.none
                    : TextDecoration.lineThrough,
              ),
            ),
            subtitle: Text(
              '${_dateFormatter.format(note.date!)} - ${note.prioridade!}',
              style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                  decoration: note.status == 0
                      ? TextDecoration.none
                      : TextDecoration.lineThrough),
            ),
            trailing: Checkbox(
              onChanged: (value) {
                note.status = value! ? 1 : 0;
                DatabaseHelper.instance.updateNote(note); //muda o status no bd
                _updateNoteList(); //refresh na lista
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => HomeScreen())); //refresh da tela
              },
              activeColor: Theme.of(context).primaryColor,
              value: note.status == 1 ? true : false,
            ),
            onTap: () => Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (_) => AddNoteScreen(
                        updateNoteList: _updateNoteList(), note: note))),
          ),
          Divider(
            height: 8.0,
            color: Theme.of(context).primaryColor,
            thickness: 2.0,
          ),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (_) => AddNoteScreen(
                        updateNoteList: _updateNoteList,
                      )))
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text("Pixel Notas"),
      ),
      body: FutureBuilder(
          future: _noteList,
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            final int completedNoteCount = snapshot.data!
                .where((Note note) => note.status == 1)
                .toList()
                .length;

            return ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                itemCount: int.parse(snapshot.data!.length.toString()) + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Minhas Notas',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '$completedNoteCount de ${snapshot.data.length}',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  return _buildNote(snapshot.data![index - 1]);
                });
          }),
    );
  }
}
