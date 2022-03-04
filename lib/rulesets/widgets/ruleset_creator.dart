import 'package:flutter/material.dart';
import 'package:ultimate_counterpicks/lists/stages.dart';
import 'package:ultimate_counterpicks/main.dart';
import 'package:ultimate_counterpicks/rulesets/classes/ruleset.dart';

import '../classes/legality.dart';


class RulesetCreator extends StatefulWidget{
  const RulesetCreator({Key? key}) : super(key: key);

  @override
  State<RulesetCreator> createState() => _RulesetCreatorState();
}

class _RulesetCreatorState extends State<RulesetCreator> {
late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  final Ruleset _ruleset = Ruleset(0,"", [
    getLegalStage(LegalStagesEnum.finalDestination),
    getLegalStage(LegalStagesEnum.battlefield)
  ], [], Legality.legal);


  @override
  Widget build(BuildContext context) {
    Ruleset readRuleset = _ruleset;

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    double stageItemHeight = height/6;
    double stageItemWidth = height/4;


    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Text("Ruleset Creator"),
      ),
      body: Center(
        child: ListView(
          children: [
            //Enter name
            Card(
              child: Padding(
                padding: const EdgeInsets.all(7),
                child: TextField(
                  controller: _controller,
                  onChanged: (name) {
                    setState(() {
                      readRuleset.name = name;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Ruleset Name"
                  ),
                ),
              ),
            ),

            //Choose Starters
            Card(
              child: SizedBox(
                height: (stageItemHeight * 4) + 75,
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: readRuleset.starters.length + 1,
                    itemBuilder: (context,index){
                      List<Widget> widgetList = [
                        ListTile(
                          trailing: IconButton(icon: const Icon(Icons.add,color: Colors.black,),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => ReloadAccess().starterStagePopup(context, readRuleset,height,width,(ruleset){
                                    setState(() {
                                      readRuleset = ruleset;
                                    });
                                  })
                              );
                            },
                          ),
                          title: const Text("Starters"),)
                      ];
                      for (var element in readRuleset.starters) {
                        widgetList.add(
                          Center(
                              child: Row(
                                children: [
                                  const Spacer(),
                                  SizedBox(child: Text(element.stageName),width: stageItemWidth/2,),
                                  const Spacer(),
                                  Image.asset(element.stageImgPath,width: stageItemWidth,),
                                  const Padding(padding: EdgeInsets.all(5)),
                                  IconButton(onPressed: (){
                                    setState(() {
                                      readRuleset.starters.removeAt(index - 1);
                                    });

                                  }, icon: const Icon(Icons.close)),
                                ],
                              )
                          )
                        );
                      }
                      return widgetList[index];
                    }),
              )
            ),

            //Counterpicks
            Card(
                child: SizedBox(
                  height: (stageItemHeight * 3) + 75,
                  child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: readRuleset.counterpicks.length + 1,
                      itemBuilder: (context,index){
                        List<Widget> widgetList = [
                          ListTile(
                            trailing: IconButton(icon: const Icon(Icons.add,color: Colors.black,),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => ReloadAccess().counterpickStagePopup(context, readRuleset,height,width,(ruleset){
                                      setState(() {
                                        readRuleset = ruleset;
                                      });
                                    })
                                );
                              },
                            ),
                            title: const Text("Counterpicks"),)
                        ];
                        for (var element in readRuleset.counterpicks) {
                          widgetList.add(
                              Center(
                                  child: Row(
                                    children: [
                                      const Spacer(),
                                      SizedBox(child: Text(element.stageName),width: stageItemWidth/2,),
                                      const Spacer(),
                                      Image.asset(element.stageImgPath,width: stageItemWidth,),
                                      const Padding(padding: EdgeInsets.all(5)),
                                      IconButton(onPressed: (){
                                        setState(() {
                                          readRuleset.counterpicks.removeAt(index - 1);
                                        });

                                      }, icon: const Icon(Icons.close)),
                                    ],
                                  )
                              )
                          );
                        }
                        return widgetList[index];
                      }),
                )
            ),
            Card(
              child: Center(
                child: TextButton(
                  child: const Text("Save and Exit"),
                  onPressed: readRuleset.starters.length != 5 || readRuleset.counterpicks.isEmpty || readRuleset.name == "" || readRuleset.containsDuplicates? null : (){
                      Future.delayed(Duration.zero,()async{
                        readRuleset.manualWriteRuleset(readRuleset);
                        reloadBool = true;
                      });
                      Navigator.pop(context);
                  }
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}




class ReloadAccess{
  Widget counterpickStagePopup(BuildContext context,Ruleset ruleset, double height, double width, Function function){
    List<Widget> columnWidgets = [];
    for (var element in LegalStagesEnum.values) {
      if(ruleset.counterpicks.length <= 2){
        switch(element.index){
          case 0:
            columnWidgets.add(
                const Center(child: Card(
                  color: Colors.blue,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Tournament Legal Stages",textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
                  ),))
            );
            columnWidgets.add(
                const Center(child: Card(
                  color: Colors.blue,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("No platform",textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
                  ),))
            );
            break;
          case 1:
            columnWidgets.add(
                const Center(child: Card(
                  color: Colors.blue,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Uniplat",style: TextStyle(color: Colors.white)),
                  ),))
            );
            break;
          case 3:
            columnWidgets.add(
                const Center(child: Card(
                  color: Colors.blue,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Biplat",style: TextStyle(color: Colors.white)),
                  ),))
            );
            break;
          case 7: columnWidgets.add(
              const Center(child: Card(
                color: Colors.blue,
                child:Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Triplat",style: TextStyle(color: Colors.white)),
                ),))
          );
          break;
          case 10: columnWidgets.add(
              const Center(child: Card(
                color: Colors.blue,
                child:Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Moving",style: TextStyle(color: Colors.white)),
                ),))
          );
          break;
        }
        columnWidgets.add(
            Row(
              children: [
                SizedBox(
                  width: width/3,
                  child: Text(getLegalStage(element).stageName,),
                ),
                const Spacer(),
                Image.asset(getLegalStage(element).stageImgPath,width: width/3,),
                IconButton(onPressed: (){
                  if(ruleset.stageListMap().containsKey(getLegalStage(element).stageName)){
                    showDialog(context: context, builder: (context) => AlertDialog(
                      insetPadding: EdgeInsets.only(top: width/2,bottom: width/2),
                      actions: [
                        IconButton(
                            onPressed: (){
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.close))
                      ],
                      content: const Center(child: Text("Stage already added, cannot have duplicates"),),

                    ));
                  }else{
                    Ruleset newRuleset = ruleset;
                    newRuleset.counterpicks.add(getLegalStage(element));
                    function(newRuleset);
                    Navigator.of(context).pop();
                  }

                }, icon: const Icon(Icons.add))
              ],
            )
        );
      } else{
        if(columnWidgets.isEmpty){
          columnWidgets.add(
            const Center(
              child: Text("Counterpicks List Full"),
            )
          );
        }
      }

    }


    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      scrollable: true,
      content: Column(
        children: columnWidgets,
      ),
      actions: [
        IconButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.close))
      ],
    );
  }

  Widget starterStagePopup(BuildContext context,Ruleset ruleset, double height, double width, Function function){
    List<Widget> columnWidgets = [];
    for (var element in LegalStagesEnum.values) {
      if (ruleset.starters.length <= 4){
        switch(element.index){
          case 0:
            columnWidgets.add(
                const Center(child: Card(
                  color: Colors.blue,
                  child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Tournament Legal Stages",textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
                ),))
            );
            columnWidgets.add(
                const Center(child: Card(
                  color: Colors.blue,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("No platform",textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
                  ),))
            );
            break;
          case 1:
            columnWidgets.add(
                const Center(child: Card(
                  color: Colors.blue,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Uniplat",style: TextStyle(color: Colors.white)),
                ),))
            );
            break;
          case 3:
            columnWidgets.add(
                const Center(child: Card(
                  color: Colors.blue,
                  child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Biplat",style: TextStyle(color: Colors.white)),
                ),))
            );
            break;
          case 7: columnWidgets.add(
              const Center(child: Card(
                color: Colors.blue,
                child:Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Triplat",style: TextStyle(color: Colors.white)),
              ),))
          );
          break;
          case 10: columnWidgets.add(
              const Center(child: Card(
                color: Colors.blue,
                child:Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Moving",style: TextStyle(color: Colors.white)),
              ),))
          );
          break;
        }
        columnWidgets.add(
            Row(
              children: [
                SizedBox(
                  width: width/3,
                  child: Text(getLegalStage(element).stageName),
                ),
                const Spacer(),
                Image.asset(getLegalStage(element).stageImgPath,width: width/3,),
                IconButton(onPressed: (){
                  if(ruleset.stageListMap().containsKey(getLegalStage(element).stageName)){
                    showDialog(context: context, builder: (context) => AlertDialog(
                      insetPadding: EdgeInsets.only(top: width/2,bottom: width/2),
                      actions: [
                        IconButton(
                            onPressed: (){
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.close))
                      ],
                      content: const Center(child: Text("Stage already added, cannot have duplicates"),),

                    ));
                  }else{
                    Ruleset newRuleset = ruleset;
                    newRuleset.starters.add(getLegalStage(element));
                    function(newRuleset);
                    Navigator.of(context).pop();
                  }
                  // Ruleset newRuleset = ruleset;
                  // newRuleset.starters.add(getLegalStage(element));
                  // function(newRuleset);
                  // Navigator.of(context).pop();
                }, icon: const Icon(Icons.add))
              ],
            )
        );
      }else{
        if(columnWidgets.isEmpty){
          columnWidgets.add( const Center(
            child: Text("Starter stages full"),
          ));
        }
      }
    }

    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      scrollable: true,
      content: Column(
        children: columnWidgets,
      ),
      actions: [
        IconButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.close))
      ],
    );
  }

}

