import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:stagelistgg/lists/default_rulesets.dart';


import 'package:stagelistgg/rulesets/classes/legality.dart';
import 'package:stagelistgg/rulesets/classes/ruleset.dart';
import 'package:stagelistgg/rulesets/widgets/counterpicks_view.dart';
import 'package:stagelistgg/rulesets/widgets/qr_reader.dart';
import 'package:stagelistgg/rulesets/widgets/ruleset_creator.dart';
import 'package:stagelistgg/web_compatible/scrolling.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animations/animations.dart';

bool reloadBool = true;
Ruleset ruleset = Ruleset(0, "", [], [], Legality.legal);
Future<List<Ruleset>> rulesetListFuture = ruleset.rulesetList;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'stagelist.gg',
      scrollBehavior: CustomScrollBehavior(),
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: SharedAxisPageTransitionsBuilder(
              transitionType: SharedAxisTransitionType.horizontal
            ),
            TargetPlatform.iOS: SharedAxisPageTransitionsBuilder(
              transitionType: SharedAxisTransitionType.horizontal
            )
          }
        ),
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      drawer: adaptiveDrawer(context, height, width),
      appBar: AppBar(
        backgroundColor: Colors.brown,
        actions: adaptiveAppBarActions(context),
      ),
      body: Center(
        child: FutureBuilder<List<Ruleset>>(
          future: rulesetListFuture,
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done){
              if(snapshot.data!.isEmpty){
                return SizedBox(
                  width: (width/8)*7,
                  child: const Center(
                    child: Text("No rulesets found, please add one using the '+' icon, or scan one using the QR code icon",textAlign: TextAlign.center,),
                  ),
                );
              }
              return ListView.builder(itemBuilder: (context,index){
                String title = (snapshot.data![index].name);
                Ruleset ruleset = snapshot.data![index];
                return Card(
                  child: ListTile(
                    title: Text(title),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: adaptiveListTileIcons(ruleset, index, context, width),
                    ),
                    onTap: () {
                      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);
                      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
                      Future.delayed(const Duration(milliseconds: 500),(){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CounterpicksView(ruleset: ruleset)));
                      });

                      },
                  ),
            );
          },
            itemCount: snapshot.data!.length,
          );
        }
        return const CircularProgressIndicator();
    },),
      ),
    );
  }

  List<Widget> adaptiveAppBarActions(BuildContext context) {
    if(kIsWeb){
      return [        
        IconButton(
          icon: const Icon(Icons.help),
          onPressed: (){
            showAboutDialog(
              context: context,
              applicationName: "stagelist.gg",
              children: [
                Wrap(
                  children: [
                                    Row(children: [
                  const Text("Created by "),
                  InkWell(child: const Text("Decade",style: TextStyle(color: Colors.blue),),
                  onTap: (){launchUrl(Uri.https("twitter.com", "/DecadeSmash"));},),
                ],)
                  ],
                ),
                Wrap(
                  children: [
                    Row(
                    children: [
                      const Text("Stage images from "),
                      InkWell(child: const Text("Smash Wiki",style: TextStyle(color: Colors.blue),),
                      onTap: (){launchUrl(Uri.https("www.ssbwiki.com"));},)
                    ],
                )
                  ],
                ),
                const Wrap(
                  children: [
                    Text("For saving custom rulesets and many other offline features please download the app on Google Play or the Apple App Store")
                  ],
                )
              ]
            );
          },
        ),];
    }
    return [
        IconButton(
          icon: const Icon(Icons.help),
          onPressed: (){
            showAboutDialog(
              context: context,
              applicationName: "stagelist.gg",
              children: [
                Row(children: [
                  const Text("Created by "),
                  InkWell(child: const Text("Decade",style: TextStyle(color: Colors.blue),),
                  onTap: (){launchUrl(Uri.https("twitter.com", "/DecadeSmash"));},),
                ],),
                Wrap(
                  children: [
                    const Text("Stage images from "),
                    InkWell(child: const Text("Smash Wiki",style: TextStyle(color: Colors.blue),),
                    onTap: (){launchUrl(Uri.https("www.ssbwiki.com"));},)
                  ],
                ),
              ]
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.qr_code),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const QrReader())).then((value){
              Future.delayed(const Duration(milliseconds: 100),(){
                setState(() {
                  rulesetListFuture = ruleset.rulesetList;
                });
              });
            });
          }
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: ()async{
            Navigator.push<List<Ruleset>>(context, MaterialPageRoute(builder: (context) => const RulesetCreator())).then((value){
              Future.delayed(const Duration(milliseconds: 100),(){
                setState(() {
                  rulesetListFuture = ruleset.rulesetList;
                });
              });
            });
          },
        ),
      ];
  }

  Drawer? adaptiveDrawer(BuildContext context, double height, double width) {
    if(kIsWeb){
      return null;
    }
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(child: Center(child: Text("Additional Options"),)),
          ListTile(
            title: const Text("Default Stagelists"),
            onTap: () {
              List<Ruleset> defaultRulesets = DefaultRulesets().rulesets;
              showDialog(context: context, 
              builder: ((context) {
                return AlertDialog(
                  actions: [
                    IconButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close))
                      ],
                  content: SizedBox(
                    height: height/2,
                    width: width/2 ,
                    child: ListView.builder(
                      itemCount: defaultRulesets.length,
                      itemBuilder: ((context, index) {
                        return ListTile(
                          title: Text(defaultRulesets[index].name),
                          onTap: (() {
                            SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);
                            SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
                            Future.delayed(const Duration(milliseconds: 500),(){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CounterpicksView(ruleset: defaultRulesets[index])));
                            });
                      }),
                      );
                  }),)
                ),
                );
              }));
            },
          )
        ],),
    );
  }

  List<Widget> adaptiveListTileIcons(Ruleset ruleset, int index, BuildContext context, double width) {
    if(kIsWeb == false){
          return [
                      // listOptionalDeleteButton(ruleset, index),
                      IconButton(
                        icon: const Icon(Icons.qr_code),
                        onPressed: (){
                          showDialog(context: context, builder: (context) => AlertDialog(
                            content: SizedBox(
                                height: (width/4) * 3,
                                width: (width/4) * 3,
                                child: QrImageView(
                                  data: jsonEncode(ruleset),
                                  version: QrVersions.auto,
                                ),
                            ),
                            actions: [
                              IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          ));
                        },
                      ),
                      listOptionalDeleteButton(ruleset, index)
                    ];
    }else{
      return [];
    }
  }

  IconButton listOptionalDeleteButton(Ruleset ruleset, int index) {
    return IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: (){
                          Future.delayed(Duration.zero,(){
                            ruleset.deleteRuleset(index);
                            ruleset.renameRulesets;
                            setState(() {
                              rulesetListFuture = ruleset.rulesetList;
                            });
                          });
                        },
                      );
  }
}

