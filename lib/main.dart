
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart'as http;

import 'screen.dart';



void main() {
  runApp( MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.teal,
      ),
      home:  WallPaperApp(),
    );
  }
}
class WallPaperApp extends StatefulWidget {
  const WallPaperApp({Key? key}) : super(key: key);

  @override
  State<WallPaperApp> createState() => _WallPaperAppState();
}

class _WallPaperAppState extends State<WallPaperApp> {
  List images=[];
      int page=1;
  late Map result;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchapi();

  }
  fetchapi() async {
      await http.get(Uri.parse('https://api.pexels.com/v1/curated?per_page=80'),
          headers: {'Authorization': 'tmwRfUbzWCj1FOUFbXCwlWjNvWLzC06xXS9BmBD42qtzT0LHt2A6ifE1'}).then((value) {
        Map result = jsonDecode(value.body);
        setState(() {
          images = result['photos'];
        });
        print(images[0]);
      });
    }
    loadmore() async{
    setState(() {
      page=page+1;
    });
    String url='https://api.pexels.com/v1/curated?per_page=80&page='+page.toString();
    await http.get(Uri.parse(url),headers: {'Authorization': 'tmwRfUbzWCj1FOUFbXCwlWjNvWLzC06xXS9BmBD42qtzT0LHt2A6ifE1'}).then((value)
    {
         Map result=jsonDecode(value.body);
                setState(() {
                  images=result['photos'];
                });
    }) ;

    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: Container(
            child: GridView.builder(
              itemCount: images.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 2,
                  childAspectRatio: 2 / 3,
                  mainAxisSpacing: 2
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Screen(imageurl:images[index]['src']['original'] ,))) ;
                  },
                    child: Container(color: Colors.teal,child: Image.network(images[index]['src']['tiny'],fit: BoxFit.cover,),));
              },
            ),
          )),
          InkWell(
            onTap:() {
              loadmore();
            },
            child: Container(
              height: 50,
              width: double.infinity,
              color: Colors.black,
              child: Center(child: Text(
                'Load more', style: TextStyle(fontSize: 20, color: Colors.red),)),
            ),
          )
        ],
      ),
    );
  }
}

