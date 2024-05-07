// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:aesthticapp/boxes/boxes.dart';
import 'package:aesthticapp/model/modals.dart';
import 'package:aesthticapp/theme/theme_constant.dart';
import 'package:aesthticapp/theme/theme_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Directory document = await getApplicationDocumentsDirectory();

  Hive.init(document.path);

//build_runner
//hive_generator

  Hive.registerAdapter(NotesModelAdapter());

  await Hive.openBox<NotesModel>('notes');

  runApp(const MyApp());
}

ThemeManager _themeManager = ThemeManager();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

@override
  void dispose() {
    _themeManager.removeListener(themelistener);
    
    super.dispose();
  }

  @override
  void initState() {
    
  _themeManager.addListener(themelistener);
    super.initState();
  }

 themelistener(){
  if(mounted){
    setState(() {
      
    });
  }
 }



  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: "NOteBook",
      debugShowCheckedModeBanner: false,
      theme: lightModeTheme,
      darkTheme: darkModeTheme,
      themeMode: _themeManager.themeMode,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
   
   const  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController titleText = TextEditingController();

  TextEditingController desc = TextEditingController();

  Future<void> edit(NotesModel notesModel,String title,String description) async {
    
    desc.text=description;
    titleText.text=title;

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actionsPadding: const EdgeInsets.all(10),
            // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)
            actions: [
              const SizedBox(
                height: 5,
              ),
              const Center(
                  child: Text(
                "Edits Notes",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: titleText,
                decoration: const InputDecoration(
                    hintText: "Enter the title", border: OutlineInputBorder()),
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                    hintText: "Enter the description",
                    border: OutlineInputBorder()),
                controller: desc,
              ),
              // const SizedBox(
              //   height: 10,
              // ),
              // Center(
              //     child: IconButton(
              //         onPressed: () {}, icon: const Icon(Icons.add_a_photo))),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () async {
                    notesModel.title=titleText.text.toString();
                    notesModel.description=desc.text.toString();
                    await notesModel.save();
                  desc.clear();
                  titleText.clear();

                    Navigator.pop(context);
                  },
                  child: const Text("Edit"))
            ],
          );
        });
  }


  Future<void> _add() async {
    return  showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  actionsPadding: const EdgeInsets.all(10),
                  // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)
                  actions: [
                    const SizedBox(
                      height: 5,
                    ),
                    const Center(
                        child: Text(
                      "Add Notes",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: titleText,
                      decoration: const InputDecoration(
                          hintText: "Enter the title",
                          border: OutlineInputBorder()),
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      style: const TextStyle(fontSize: 18),
                      decoration: const InputDecoration(
                          hintText: "Enter the description",
                          border: OutlineInputBorder()),
                      controller: desc,
                    ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // Center(
                    //     child: IconButton(
                    //         onPressed: () {}, icon: const Icon(Icons.add_a_photo))),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          final data = NotesModel(
                              title: titleText.text, description: desc.text);

                          //box modal
                          final box = Boxes.getData();
                          box.add(data);
                          // data.save();

                          titleText.clear();
                          desc.clear();

                          Navigator.pop(context);
                        },
                        child: const Text("Add"))
                  ],
                );
              });
  }



  void delete(NotesModel notesModel) async {
    await notesModel.delete();
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(

     appBar: AppBar(
        title: const Text("NOteBook"),
        centerTitle: true,
        
        
      actions: [
       Switch(value: _themeManager.themeMode==ThemeMode.dark, onChanged: (newvalue){
           _themeManager.toggleTheme(newvalue);
       }) ,
       const SizedBox(width: 5,),
      
      PopupMenuButton(itemBuilder: (context)=>[
        PopupMenuItem(child:Row(
          children: [
            Icon(Icons.person,color: (_themeManager.themeMode==ThemeMode.dark)?Colors.white:PRIMARY_COLOR,),
            SizedBox(width: 2,),
            Text("Himanshu"),
          ],
        ) ),
        PopupMenuItem(child:Row(
          children: [
            Icon(Icons.email,color:  (_themeManager.themeMode==ThemeMode.dark)?Colors.white:PRIMARY_COLOR,),
            SizedBox(width: 2,),
            Text("HimanshuSwami2810@gmail.com",style: TextStyle(fontSize: 15),),
          ],
             ),)
      
      ]
         ),
      
      const SizedBox(width: 5,),
        ],
       ),

      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context, box, _) {
          var data = box.values.toList().cast<NotesModel>();
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              return Card(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20,right: 20),
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width*0.8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data[index].title.toString()),
                                         SizedBox(height: 5,),
                                  Text(data[index].description.toString()),
                                          SizedBox(height: 5,),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  InkWell(
                                      onTap: () {
                                         edit(data[index], data[index].title.toString(), data[index].description.toString());
                                      }, child: const Icon(Icons.edit)),
                                  InkWell(
                                      onTap: () {
                                         delete(data[index]);
                                      },
                                      child: const Icon(Icons.delete)),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
         _add();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}








class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        
        title: Text("NOtePad"),
        
        
        actions: [
       Switch(value: _themeManager.themeMode==ThemeMode.dark, onChanged: (onvalue){
           _themeManager.toggleTheme(onvalue);
       }) ,
       SizedBox(width: 35,)
       
      ]),
      body: Container(
        child: Column(children: [
                  
          Card(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20,right: 20),
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width*0.8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("1"),
                                  SizedBox(height: 5,),
                                  Text("2hggghghhgggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggghhhhhhhhhhhhhhgggggggggggggggggggggggggr"),
                                  SizedBox(height: 5,),
                                ],
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  InkWell(
                                      onTap: () {
                                        // edit(data[index], data[index].title.toString(), data[index].description.toString());
                                      }, child: const Icon(Icons.edit)),
                                  InkWell(
                                      onTap: () {
                                        // delete(data[index]);
                                      },
                                      child: const Icon(Icons.delete)),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
    
                  Card(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20,right: 20),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Text("1"),
                                Text("2"),
                              ],
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  InkWell(
                                      onTap: () {
                                        // edit(data[index], data[index].title.toString(), data[index].description.toString());
                                      }, child: const Icon(Icons.edit)),
                                  InkWell(
                                      onTap: () {
                                        // delete(data[index]);
                                      },
                                      child: const Icon(Icons.delete)),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                
        ]),
      ),
       floatingActionButton: FloatingActionButton(onPressed: (){},child: Icon(Icons.add),),
    );
  }
}