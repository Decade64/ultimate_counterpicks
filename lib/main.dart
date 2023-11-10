import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';


import 'package:ultimate_counterpicks/rulesets/classes/legality.dart';
import 'package:ultimate_counterpicks/rulesets/classes/ruleset.dart';
import 'package:ultimate_counterpicks/rulesets/widgets/counterpicks_view.dart';
import 'package:ultimate_counterpicks/rulesets/widgets/qr_reader.dart';
import 'package:ultimate_counterpicks/rulesets/widgets/ruleset_creator.dart';
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
      title: 'Ultimate Counterpicks',
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        actions: [
          IconButton(
            icon: const Icon(Icons.help),
            onPressed: (){
              showAboutDialog(
                context: context,
                applicationName: "Ultimate Counterpicks",
                children: [
                  Row(children: [
                    const Text("Created by "),
                    InkWell(child: const Text("Decade",style: TextStyle(color: Colors.blue),),
                    onTap: (){launch("https://twitter.com/DecadeSmash");},),
                  ],),
                  Row(
                    children: [
                      const Text("Stage images from "),
                      InkWell(child: const Text("Smash Wiki",style: TextStyle(color: Colors.blue),),
                      onTap: (){launch("https://www.ssbwiki.com");},)
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
                Future.delayed(const Duration(milliseconds: 50),(){
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
                Future.delayed(const Duration(milliseconds: 50),(){
                  setState(() {
                    rulesetListFuture = ruleset.rulesetList;
                  });
                });
              });
            },
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<List<Ruleset>>(
          future: rulesetListFuture,
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done ){
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
                      children: [
                        IconButton(
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
                        ),
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
                        )
                      ],
                    ),
                    onTap: () {
                      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);
                      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
                      Future.delayed(const Duration(milliseconds: 400),(){
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
}

