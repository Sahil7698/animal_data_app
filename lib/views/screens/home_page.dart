import 'dart:typed_data';

import 'package:animal_data_app/model/global.dart';
import 'package:animal_data_app/views/screens/category_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../helper/animal_helpers.dart';
import '../../model/animal_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Animal>> getAnimals;

  final GlobalKey<FormState> insertFormKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController decController = TextEditingController();

  String? name;
  String? dec;
  Uint8List? imageBytes;

  getFromGallery() async {
    ImagePicker picker = ImagePicker();

    XFile? xFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );

    imageBytes = await xFile!.readAsBytes();
  }

  @override
  void initState() {
    super.initState();
    getAnimals = DBHelper.dbHelper.getAllRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Animal App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "Animal\nDetails",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 200,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    left: 20,
                  ),
                  width: 300,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.black12,
                    image: const DecorationImage(
                      image: NetworkImage(
                        "https://thumbs.dreamstime.com/b/large-group-african-safari-animals-wildlife-conservation-concept-174172993.jpg",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    left: 20,
                  ),
                  width: 300,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.black12,
                    image: const DecorationImage(
                      image: NetworkImage(
                        "https://thumbs.dreamstime.com/b/collage-wild-animals-birds-nature-33582272.jpg",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    left: 20,
                  ),
                  width: 300,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.black12,
                    image: const DecorationImage(
                      image: NetworkImage(
                        "https://thumbs.dreamstime.com/b/collage-wild-animals-birds-29837164.jpg",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 8,
                  children: List.generate(
                    Global.allAnimalList.length,
                    (i) => GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CategoryPage(
                                name: "${Global.allAnimalList[i]['Name']}"),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 140,
                            width: 250,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(
                                  "${Global.allAnimalList[i]['Image']}",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                            ),
                            child: Text(
                              "${Global.allAnimalList[i]['Name']}",
                              style: GoogleFonts.actor(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 25,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: () {
          InsertAnimalDetails();
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void InsertAnimalDetails() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Center(
            child: Text("Insert Record"),
          ),
          content: Form(
            key: insertFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: GestureDetector(
                    onTap: () {
                      getFromGallery();
                    },
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.pink.shade100,
                      child: const Text(
                        "ADD",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.pink,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  controller: nameController,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Enter Name First...";
                    }
                    return null;
                  },
                  onSaved: (val) {
                    name = val;
                  },
                  decoration: InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: decController,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Enter Description...";
                    }
                    return null;
                  },
                  onSaved: (val) {
                    name = val;
                  },
                  decoration: InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                nameController.clear();
                decController.clear();
                setState(() {
                  name = null;
                  dec = null;
                  imageBytes = null;
                });
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            OutlinedButton(
              onPressed: () async {
                if (insertFormKey.currentState!.validate()) {
                  insertFormKey.currentState!.save();

                  Animal a1 = Animal(
                    name: name!,
                    dec: dec!,
                    image: imageBytes!,
                  );

                  int id = await DBHelper.dbHelper.insertRecord(animal: a1);

                  if (id > 0) {
                    setState(() {
                      getAnimals = DBHelper.dbHelper.getAllRecords();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("$id : Record Inserted successfully..."),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Record Insertion failed..."),
                        backgroundColor: Colors.redAccent,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                }

                nameController.clear();
                decController.clear();

                setState(() {
                  name = null;
                  dec = null;
                  imageBytes = null;
                });

                Navigator.pop(context);
              },
              child: const Text("Insert"),
            ),
          ],
        );
      },
    );
  }
}
