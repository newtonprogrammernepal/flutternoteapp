import 'package:flutter/material.dart';

import 'Models/NotesPage.dart';

class NotesPage extends StatefulWidget {
  NotesPage({Key key}) : super(key: key);
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  var _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    notesDescriptionMaxLength =
        notesDescriptionMaxLines * notesDescriptionMaxLines;
  }

  void dispose() {
    super.dispose();
    noteDescriptionController.dispose();
    noteHeadingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: notesHeader(),
      ),
      body: noteHeading.length > 0
          ? buildNotes()
          : Center(
              child: Text("Add Note"),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          _settingModalBottomSheet(context);
        },
        child: Icon(Icons.create),
      ),
    );
  }

  Widget buildNotes() {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
      child: ListView.builder(
        itemCount: noteHeading.length,
        itemBuilder: (context, int index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 5.5),
            child: Dismissible(
              key: new UniqueKey(),
              direction: DismissDirection.horizontal,
              onDismissed: (direction) {
                setState(() {
                  deletedNoteHeading = noteHeading[index];
                  deletedNoteDescription = noteDescription[index];
                  noteHeading.removeAt(index);
                  noteDescription.removeAt(index);
                  Scaffold.of(context).showSnackBar(
                    new SnackBar(
                      backgroundColor: Colors.purple,
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Note Deleted"),
                          deletedNoteHeading != ""
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (deletedNoteHeading != "") {
                                        noteHeading.add(deletedNoteHeading);
                                        noteDescription
                                            .add(deletedNoteDescription);
                                      }
                                      deletedNoteHeading = "";
                                      deletedNoteDescription = "";
                                    });
                                  },
                                  child: Text("Undo"),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                  );
                });
              },
              background: ClipRRect(
                borderRadius: BorderRadius.circular(5.5),
                child: Container(
                  color: Colors.green,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          Text(
                            "Delete",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              secondaryBackground: ClipRRect(
                borderRadius: BorderRadius.circular(5.5),
                child: Container(
                  color: Colors.red,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          Text(
                            "Delete",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              child: noteList(index),
            ),
          );
        },
      ),
    );
  }

  Widget noteList(int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.5),
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: noteColor[(index % noteColor.length).floor()],
          borderRadius: BorderRadius.circular(5.5),
        ),
        child: Center(
          child: Row(
            children: [
              Container(
                color: noteMarginColor[(index % noteColor.length).floor()],
                width: 3.5,
                height: double.infinity,
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          noteHeading[index],
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 2.5,
                      ),
                      Flexible(
                        child: Container(
                            height: double.infinity,
                            child: Text(
                              "${(noteDescription[index])}",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      elevation: 50,
      isDismissible: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (BuildContext bc) {
        return Padding(
          padding: EdgeInsets.only(left: 25, right: 25),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: (MediaQuery.of(context).size.height)),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 250, top: 50),
                  child: new Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "New Note",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  noteHeading.add(noteHeadingController.text);
                                  noteDescription
                                      .add(noteDescriptionController.text);
                                  noteHeadingController.clear();
                                  noteDescriptionController.clear();
                                });
                                Navigator.pop(context);
                              }
                            },
                            child: Container(
                              child: Row(
                                children: [
                                  Text(
                                    "Save",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.blueAccent,
                        thickness: 2.5,
                      ),
                      TextFormField(
                        maxLength: notesHeaderMaxLength,
                        controller: noteHeadingController,
                        decoration: InputDecoration(
                          hintText: 'Note Header',
                          hintStyle: TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: Icon(Icons.text_fields),
                        ),
                        validator: (String noteHeading) {
                          if (noteHeading.isEmpty) {
                            return "Enter Note Heading";
                          } else if (noteHeading.startsWith(" ")) {
                            return "Please avoid whitespaces";
                          }
                        },
                        onFieldSubmitted: (String value) {
                          FocusScope.of(context)
                              .requestFocus(textSecondFocusNode);
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Container(
                          margin: EdgeInsets.all(1),
                          height: 5 * 24.0,
                          child: TextFormField(
                            focusNode: textSecondFocusNode,
                            maxLines: notesDescriptionMaxLines,
                            maxLength: notesDescriptionMaxLength,
                            controller: noteDescriptionController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Decoration",
                              hintStyle: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500),
                            ),
                            validator: (String noteDescription) {
                              if (noteDescription.isEmpty) {
                                return "Enter Note Description";
                              } else if (noteDescription.startsWith(" ")) {
                                return "Avoid whiteSpaces";
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget notesHeader() {
  return Padding(
    padding: EdgeInsets.only(top: 10, left: 2.5, right: 2.5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My Notes',
          style: TextStyle(
            color: Colors.blueAccent,
            fontSize: 25.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        Divider(
          color: Colors.blueAccent,
          thickness: 2.5,
        ),
      ],
    ),
  );
}
