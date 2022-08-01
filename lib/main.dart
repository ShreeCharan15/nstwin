import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:nstwin/back.dart';
import 'package:nstwin/result.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Style Transfer',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home:  ChangeNotifierProvider(create: (_)=>Back(),child:  Home(),),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  List<File> pickedFiles=[];

  Widget showFiles(){
    List<Widget> ims=pickedFiles.map((file) =>  Flexible(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 200
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Image.file(file,height: 100),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(child: Text(file.uri.pathSegments.last)),
                    IconButton(icon:  Icon(Icons.delete_outline,size: 20,color: Colors.red[600],),onPressed: ()=>delFile(file),)
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    )).toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ...ims
      ],
    );
  }
  
  void delFile(File file){
    pickedFiles = pickedFiles.where((element) => element.path!=file.path).toList();
    setState(() {
      pickedFiles;
    });

  }
  
  void pickFile()async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
      type: FileType.image,
    );

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      List<String> paths=pickedFiles.map((e) => e.path).toList();
      files=files.where((element) => !paths.contains(element.path)).toList();
      pickedFiles=[...pickedFiles,...files];
      setState(() {
        pickedFiles;
      });
    } else {
      // User canceled the picker
    }

  }

  Widget showStyles(){
    List<Map<String,String>> styles=[
      {'Build':'build.jpg'},
      {'Candy':'candy.jpg'},
      {'Cubist':'cubist.jpg'},
      {'Edtaonisl':'edtaonisl.jpg'},
      {'Fur':'fur.jpg'},
      {'Hundertwasser':'hundertwasser.jpg'},
      {'Kandinsky':'kandinsky.jpg'},
      {'Scream':'scream.jpg'},
      {'Starry Night':'starrynight.jpg'},
      {'Sunset':'tree.jpg'},
      {'Waves':'waves.png'}
    ];
    List<Widget> ims=styles.map((style) =>  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        constraints: const BoxConstraints(
            maxWidth: 200
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.asset('images/styles/${style.values.first}',height: 100),
              ),
            ),


          ],
        ),
      ),
    )).toList();
    return Wrap(

      children: [
        ...ims
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Back>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Style Transfer'),

      ),
      floatingActionButton: FloatingActionButton(onPressed: pickFile,
        child: const Icon(Icons.add),

      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                // const Text("Pick File (png, jpg, jpeg)"),
                showFiles(),

                const SizedBox(height: 10,),
                const Padding(
                  padding:  EdgeInsets.all(8.0),
                  child:  Text("Styles",style: TextStyle(fontSize: 30),),
                ),
                showStyles(),
                const SizedBox(height: 10,),
                CupertinoButton.filled(onPressed: pickedFiles.isNotEmpty?(){
                  provider.transform(pickedFiles.map((e) => e.path).toList());
                }:null, child: const Text("Apply styles on selected images",
                    style: TextStyle(fontSize: 20)
                )),
                const Text("(PS: Images with dimesnsion greater than 720p will be scaled down to 720p)",style: TextStyle(color: Colors.grey),),
                const SizedBox(height: 10,),

                const Result()

              ],
            ),
          ),
        ),
      ),
    );
  }
}




