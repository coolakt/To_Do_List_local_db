import 'package:flutter/material.dart';
import 'package:untitled/data/local/db_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  List<Map<String, dynamic>> allNotes = [];
  DbHelper? dBRef;
  @override
  void initState() {
    super.initState();
    dBRef = DbHelper.getInstances;
    getNotes();
  }

  void getNotes() async {
    allNotes = await dBRef!.getAllNotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
      ),
      body: allNotes.isNotEmpty
          ? ListView.builder(
              itemCount: allNotes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Text("${index + 1}"),
                  title: Text(allNotes[index][DbHelper.COLUMN_NOTE_TITLE]),
                  subtitle: Text(allNotes[index][DbHelper.COLUMN_NOTE_DESC]),
                  trailing: SizedBox(
                    width: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                            onTap: () {
                              showBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    titleController.text = allNotes[index]
                                        [DbHelper.COLUMN_NOTE_TITLE];
                                    descController.text = allNotes[index]
                                        [DbHelper.COLUMN_NOTE_DESC];
                                    return getBottomSheetWidget(
                                        isUpdate: true,
                                        sno: allNotes[index]
                                            [DbHelper.COLUMN_NOTE_SNO]);
                                  });
                            },
                            child: Icon(Icons.edit)),
                        InkWell(
                            onTap: () async {
                              bool check = await dBRef!.deleteData(
                                  sNo: allNotes[index]
                                      [DbHelper.COLUMN_NOTE_SNO]);
                              if (check) {
                                getNotes();
                              }
                            },
                            child: Icon(Icons.delete))
                      ],
                    ),
                  ),
                );
              })
          : Center(
              child: Text("No Notes Yet!"),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return getBottomSheetWidget();
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget getBottomSheetWidget({bool isUpdate = false, int sno = 0}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(11),
      child: Column(
        children: [
          Text(
            isUpdate ? "Update Note" : "Add Note",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 21,
          ),
          TextField(
            controller: titleController,
            decoration: InputDecoration(
                hintText: "Enter title here",
                label: Text("Title"),
                enabledBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11))),
          ),
          SizedBox(
            height: 11,
          ),
          TextField(
            controller: descController,
            maxLines: 4,
            decoration: InputDecoration(
                hintText: "Enter desc here",
                label: Text("Desc"),
                enabledBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11))),
          ),
          SizedBox(
            height: 11,
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11))),
                    onPressed: () async {
                      var title = titleController.text;
                      var desc = descController.text;
                      if (title.isNotEmpty && desc.isNotEmpty) {
                        bool check = isUpdate
                            ? await dBRef!
                                .update(mTitle: title, mDesc: desc, sNo: sno)
                            : await dBRef!.addNote(mTitle: title, mDesc: desc);
                        if (check) {
                          getNotes();
                        }

                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text("Please fill all the require blanks!!")));
                        Navigator.pop(context);
                      }
                      titleController.clear();
                      descController.clear();
                    },
                    child: Text(isUpdate ? "Update" : "Add Note")),
              ),
              SizedBox(
                width: 4,
              ),
              Expanded(
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11))),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancel")))
            ],
          )
        ],
      ),
    );
  }
}
