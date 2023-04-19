import 'package:flutter/material.dart';

import '../../helper/animal_helpers.dart';
import '../../model/animal_model.dart';

class CategoryPage extends StatefulWidget {
  final String name;
  const CategoryPage({Key? key, required this.name}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late Future<List<Animal>> getAnimals;

  @override
  void initState() {
    super.initState();
    getAnimals = DBHelper.dbHelper.fetchSearchRecords(Name: widget.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: getAnimals,
            builder: (context, snapShot) {
              if (snapShot.hasError) {
                return Center(
                  child: Text("ERROR : ${snapShot.error}"),
                );
              } else if (snapShot.hasData) {
                List<Animal>? data = snapShot.data;
                return (data == null || data.isEmpty)
                    ? const Center(
                        child: Text(
                          "No Data Available....",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, i) {
                          return Padding(
                            padding: const EdgeInsets.all(6),
                            child: Card(
                              color: Colors.grey.shade200,
                              elevation: 3,
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.blueGrey,
                                  backgroundImage: MemoryImage(data[i].image),
                                ),
                                title: Text(data[i].name),
                                subtitle: Text(data[i].dec),
                                trailing: IconButton(
                                  onPressed: () async {
                                    int res = await DBHelper.dbHelper
                                        .deleteRecords(id: data[i].id!);

                                    if (res == 1) {
                                      setState(() {
                                        getAnimals = DBHelper.dbHelper
                                            .fetchSearchRecords(
                                                Name: widget.name);
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              "Record Deleted successfully..."),
                                          backgroundColor: Colors.green,
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text("Record Deletion failed..."),
                                          backgroundColor: Colors.redAccent,
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          );
                        },
                      );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }
}
