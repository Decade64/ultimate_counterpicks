import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ultimate_counterpicks/lists/default_rulesets.dart';

import 'package:ultimate_counterpicks/rulesets/classes/stage.dart';
import 'legality.dart';


part 'ruleset.g.dart';

@JsonSerializable(explicitToJson: true)
class Ruleset{
  int id;
  String name;
  List<Stage> starters;
  List<Stage> counterpicks;
  Legality legality;

  Ruleset(this.id,this.name, this.starters, this.counterpicks, this.legality);

  List<Stage> stageList(){
    List<Stage> data = [];
    for (var element in starters) {data.add(element);}
    for (var element in counterpicks) {data.add(element);}
    return data;
  }

  Map<String,Stage> stageListMap(){
    Map<String,Stage> listMap = {};
    stageList().forEach((stage) {
      listMap[stage.stageName] = stage;
    });
    return listMap;
  }

bool get containsDuplicates{
    int index = 0;
    bool duplicates = false;
    Map<String,Stage> working = {};
    stageList().forEach((stage) {
      if(working.containsKey(stage.stageName)){
        duplicates = true;
      }else{
        working[stage.stageName] = stage;
      }
      index = index + 1;
    });
    return duplicates;
}

  // List<Stage> counterpickDuplicates(){
  //   List<Stage> data = [];
  //   List<Stage> working = [];
  //   counterpicks.forEach((stage) {
  //     if(working.contains(stage)){
  //       data.add(stage);
  //     }
  //     working.add(stage);
  //   });
  //   return data;
  // }

  factory Ruleset.fromJson(Map<String,dynamic> json) => _$RulesetFromJson(json);
  Map<String,dynamic> toJson() => _$RulesetToJson(this);
  //Read/Write ruleset

    //get file
  //Get directory
  Future<String> get _documentDirectory async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<String> get _rulesetDocumentDirectory async{
    return "${await _documentDirectory}/rulesets/";
  }

  //Get file
  Future<File> get _rulesetFile async {
    final path = await _documentDirectory;
    return File('$path/ruleset.json');
  }

  //Get file from index
  Future<File> _rulesetIndexFile(int index) async{
    final path = await _rulesetDocumentDirectory;
    return File("${path + index.toString()}.json");
  }

    //Read/write
  //Write
  Future<File> manualWriteRuleset(Ruleset ruleset) async{
    List<Ruleset> rulesets = await rulesetList;
    int newFileId = rulesets.length;
    ruleset.id = newFileId;
    Directory dir = Directory(await _rulesetDocumentDirectory);
    if(await dir.exists() == false){
      dir.create();
      final file = await writeRuleset;
      return file.writeAsString(jsonEncode(ruleset));
    }
    ruleset.id = ruleset.id + 1;
    final file = await _rulesetIndexFile(newFileId);
    return file.writeAsString(jsonEncode(ruleset));
  }

  Future<File> get writeRuleset async{
    final file = await _rulesetFile;
    return file.writeAsString(jsonEncode(this));
  }

  //Read
  Future<Ruleset> get readRuleset async{
      var file = await _rulesetFile;
      String jsonContents = await file.readAsString();
      Map<String,dynamic> rulesetJsonMap = jsonDecode(jsonContents);
      Ruleset ruleset = Ruleset.fromJson(rulesetJsonMap);
      return ruleset;
  }

  Future<Ruleset> get readSingleRuleset async{
    var file = await _rulesetFile;
    String jsonContents = await file.readAsString();
    Map<String,dynamic> rulesetJsonMap = jsonDecode(jsonContents);
    Ruleset ruleset = Ruleset.fromJson(rulesetJsonMap);
    return ruleset;
  }

  //Read index
Future<Ruleset> readIndexRuleset(int index) async{
    var file = await _rulesetIndexFile(index);

    String jsonContents = await file.readAsString();
    Map<String,dynamic> rulesetJsonMap = jsonDecode(jsonContents);
    Ruleset ruleset = Ruleset.fromJson(rulesetJsonMap);
    return ruleset;
}
    //Delete

//  //Find number of rulesets
//  Future<int> get rulesetCount async{
//    int count = 0;
//    Directory dir = Directory.fromUri(Uri.directory(await _rulesetDocumentDirectory));
//    dir.list().forEach((element) {
//      count = count + 1;
//    });
//    return count;
//  }

  Future<List<Ruleset>> get rulesetList async{
    if(kIsWeb){
      return DefaultRulesets().rulesets;
    }
    final String dirString = await _rulesetDocumentDirectory;
    final Directory dir = Directory(dirString);
    List<Ruleset> data = [];
    int loopId = 0;
    if(await dir.exists() == false){
      dir.create();
    }else{
      await for (var entity in dir.list(recursive: true, followLinks: false)){
        if(entity is File){
          String jsonString = await entity.readAsString();
          try{
            Map<String,dynamic> json = jsonDecode(jsonString);
            Ruleset currentRuleset = Ruleset.fromJson(json);
            currentRuleset.id = loopId;
            loopId = loopId + 1;
            data.add(currentRuleset);
          }finally{}
        }
      }
    }
    return data;
  }
  //Delete
  Future deleteRuleset(int index)async{
    renameRulesets;
    final file = await _rulesetIndexFile(index);
    file.delete();
  }

  Future get renameRulesets async {
    final String dirString = await _rulesetDocumentDirectory;
    final Directory dir = Directory(dirString);
    int loopId = 0;
    await for (var entity in dir.list(recursive: true, followLinks: false)){
      if(entity is File){
        try{
          entity.rename("${dirString + loopId.toString()}.json");
          loopId = loopId + 1;
        }finally{}
      }
    }
  }
}