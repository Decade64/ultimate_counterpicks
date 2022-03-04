import 'package:json_annotation/json_annotation.dart';
import 'legality.dart';

part 'stage.g.dart';

@JsonSerializable()
class Stage{
  String stageName;
  String stageImgPath;
  Legality legality;
  bool isBanned;

  Stage(this.stageName,this.stageImgPath,this.legality,this.isBanned);

  factory Stage.fromJson(Map<String,dynamic> json) => _$StageFromJson(json);
  Map<String,dynamic> toJson() => _$StageToJson(this);
}



