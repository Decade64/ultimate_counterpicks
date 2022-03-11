import 'package:flutter/material.dart';
import 'package:ultimate_counterpicks/rulesets/classes/ruleset.dart';
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
    PreferredSizeWidget _appBar = PreferredSize(
      preferredSize: const Size.fromHeight(30),
      child: AppBar(
        foregroundColor: Colors.white,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
    );
    
    return Container(child: SafeArea(
      child: extracted_scaffold(context, _appBar),
      bottom: false,
    ),
      color: Colors.brown,
    );
    
  }
  Scaffold extracted_scaffold(BuildContext context, PreferredSizeWidget _appBar) {
    double width = MediaQuery.of(context).size.width - (MediaQuery.of(context).padding.left + MediaQuery.of(context).padding.right);
    double height = MediaQuery.of(context).size.height - (_appBar.preferredSize.height + MediaQuery.of(context).padding.top + MediaQuery.of(context).padding.bottom);
    
    double starterStageWidth = (width/5);
    double counterStageWidth = ((width/8) * 3) + 8;
    
    List<Stage> starters = widget.ruleset.starters;
    List<Stage> counterpicks = widget.ruleset.counterpicks;
    
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: _appBar,
      body:Center(
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: [
              Column(
                children: [
                  Row(
                    children: const [
                      Card(
                        color: Colors.blue,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Starters",style: TextStyle(color: Colors.white),),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    width: starterStageWidth * starters.length,
                    height: (height * 2)/8,
                    child:ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: starters.length,
                        itemBuilder: (context,index){
                          if(starters[index].isBanned){
                            return InkWell(
                                onTap: (){
                                  starters[index].isBanned = false;
                                  setState(() {});
                                },
                                child: SizedBox(
                                  width: starterStageWidth,
                                  child: Card(
                                      color: Colors.red,
                                      child: Center(child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Image.asset(starters[index].stageImgPath,),
                                      ))
                                  ),
                                )
                            );
                          }else{
                            return InkWell(
                                onTap: (){
                                  starters[index].isBanned = true;
                                  setState(() {});
                                },
                                child: SizedBox(
                                  width: starterStageWidth,
                                  child: Card(
                                      color: Colors.green,
                                      child: Center(child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Image.asset(starters[index].stageImgPath),
                                      ))
                                  ),
                                )
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
                  SizedBox(
                    width: counterStageWidth * counterpicks.length,
                    height: ((height * 4)/8) - 10,
                    child:ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: counterpicks.length,
                        itemBuilder: (context,index){
                          if(counterpicks[index].isBanned){
                            return InkWell(
                                onTap: (){
                                  counterpicks[index].isBanned = false;
                                  setState(() {});
                                },
                                child: SizedBox(
                                  width: counterStageWidth,
                                  child: Card(
                                      color: Colors.red,
                                      child: Center(child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Image.asset(counterpicks[index].stageImgPath),
                                      ))
                                  ),
                                )
                            );
                          }else{
                            return InkWell(
                                onTap: (){
                                  counterpicks[index].isBanned = true;
                                  setState(() {});
                                },
                                child: SizedBox(
                                  width: counterStageWidth,
                                  child: Card(
                                      color: Colors.green,
                                      child: Center(child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Image.asset(counterpicks[index].stageImgPath),
                                      ))
                                  ),
                                )
                            );
                          }
                        }),
                  ),
                ],
              )
            ],
          ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
              for (var stage in starters) {
                stage.isBanned = false;
              }
              for (var stage in counterpicks) {
                stage.isBanned = false;
              }
              setState(() {});
        },
        child: const Icon(Icons.refresh),
        backgroundColor: Colors.green,
      ),
    );
  }
}