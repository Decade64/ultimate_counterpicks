import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stagelistgg/rulesets/classes/ruleset.dart';
import 'package:flutter/services.dart';
import '../classes/stage.dart';

class CounterpicksView extends StatefulWidget{
  final Ruleset ruleset;
  const CounterpicksView({Key? key, required this.ruleset}) : super(key: key);



@override
  State<CounterpicksView> createState() => _CounterpicksViewState();
}

class _CounterpicksViewState extends State<CounterpicksView> {
  
  
  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget appBar = PreferredSize(
      preferredSize: const Size.fromHeight(30),
      child: AppBar(
        foregroundColor: Colors.white,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
    );

    return Container(color: Colors.brown,child: SafeArea(
        bottom: false,
        child: extractedScaffold(context, appBar),
      ),
    );
  
  }
  Scaffold extractedScaffold(BuildContext context, PreferredSizeWidget appBar) {
    double width = MediaQuery.of(context).size.width - (MediaQuery.of(context).padding.left + MediaQuery.of(context).padding.right);
    double height = MediaQuery.of(context).size.height - (appBar.preferredSize.height + MediaQuery.of(context).padding.top + MediaQuery.of(context).padding.bottom);
   
    double starterStageWidth = (width/5);
    double counterStageWidth = ((width/3));
    double stageHeight = height/3.5;

    List<Stage> starters = widget.ruleset.starters;
    List<Stage> counterpicks = widget.ruleset.counterpicks;

    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: appBar,
      body:Center(
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: [
            Column(
              children: [
                const Row(
                  children: [
                    Card(
                      color: Colors.blue,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Starters",style: TextStyle(color: Colors.white),),
                      ),
                    )
                  ],
                ),
                //Starters
                SizedBox(
                  width: starterStageWidth * starters.length,
                  // width: width,
                  height: (height/2.5) - 10,
                  child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: starters.length,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: starterStageWidth,childAspectRatio: 0.65),
                      itemBuilder: (context, index) {
                        if (starters[index].isBanned) {
                          return Column(
                            children: [
                              const Spacer(),
                              InkWell(
                                  onTap: () {
                                    starters[index].isBanned = false;
                                    setState(() {});
                                  },
                                  child: SizedBox(
                                    child: Card(
                                        color: Colors.red,
                                        child: Center(child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Image.asset(starters[index].stageImgPath,),
                                        ))),
                                  )),
                              const Spacer(),
                            ],
                          );
                        }else{
                          return Column(
                            children: [
                              const Spacer(),
                              InkWell(
                                  onTap: () {
                                    starters[index].isBanned = true;
                                    setState(() {});
                                  },
                                  child: SizedBox(
                                    child: Card(
                                        color: Colors.green,
                                        child: Center(child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Image.asset(starters[index].stageImgPath),
                                        ))),
                                  )),
                              const Spacer(),
                            ],
                          );
                        }
                      }),
                ),
                const Card(
                  color: Colors.blue,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Counterpicks",style: TextStyle(color: Colors.white),),
                  ),
                ),
                //Counterpicks
                SizedBox(
                  width: counterStageWidth * counterpicks.length,
                  height: (height/3.5),
                  child:ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: counterpicks.length,
                      // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1,),
                      itemBuilder:(context,index) {
                        if (counterpicks[index].isBanned) {
                          return Column(
                            children: [
                              const Spacer(),
                              SizedBox(
                                  width: counterStageWidth,
                                  child: Row(children: [
                                    const Spacer(),
                                    SizedBox(
                                      width: counterStageWidth,
                                      height: stageHeight,
                                      child: Center(child: InkWell(
                                          onTap: () {
                                            counterpicks[index].isBanned = false;
                                            setState(() {});
                                          },
                                          child:Card(
                                              color: Colors.red,
                                              child: Padding(
                                                padding: const EdgeInsets.all(3),
                                                child: Image.asset(counterpicks[index].stageImgPath),
                                              ),
                                            ),
                                              ),),
                                    ),
                                    const Spacer(),
                                  ],)),
                              const Spacer(),
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              const Spacer(),
                              SizedBox(
                                  width: counterStageWidth,
                                  // height: stageHeight,
                                  child: Row(children: [
                                    const Spacer(),
                                    SizedBox(
                                      width: counterStageWidth,
                                      height: stageHeight,
                                      child: Center(child: InkWell(
                                          onTap: () {
                                            counterpicks[index].isBanned = true;
                                            setState(() {});
                                          },
                                          child: Card(
                                              color: Colors.green,
                                              child: Padding(
                                                padding: const EdgeInsets.all(3),
                                                child: Image.asset(counterpicks[index].stageImgPath),
                                              ),
                                            ),
                                              ),),
                                    ),
                                    const Spacer(),
                                  ],)),
                              const Spacer(),
                            ],
                          );
                        }
                      }),
                ),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: Column(
        children: [
          const Spacer(),
          FloatingActionButton(
            heroTag: null,
            onPressed:(){
              Random r = Random();
              bool isHeads = r.nextBool();
              String flipText = "";
              switch(isHeads){
                case true:
                  flipText = "Heads";
                  break;
                case false:
                  flipText = "Tails";
              }
              showDialog(context: context, builder: (context) => AlertDialog(
                        content: Center(child: Text(flipText)),
                        actions: [
                          IconButton(
                              onPressed: (){
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(Icons.close))
                        ],
                      ));
            },
            child: const Stack(
              children: [
                Center(child: Icon(Icons.circle,color: Colors.grey,size: 40,)),
                Center(child: Text("¢")),
              ],
            ),
          ),
          FloatingActionButton(
            heroTag: null,
            onPressed: (){
              for (var stage in starters) {
                stage.isBanned = false;
              }
              for (var stage in counterpicks) {
                stage.isBanned = false;
              }
              setState(() {});
            },
            backgroundColor: Colors.green,
            child: const Icon(Icons.refresh),
          )
        ],
      ),
    );
  }
}
