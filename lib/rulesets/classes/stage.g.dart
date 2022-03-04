// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Stage _$StageFromJson(Map<String, dynamic> json) => Stage(
      json['stageName'] as String,
      json['stageImgPath'] as String,
      $enumDecode(_$LegalityEnumMap, json['legality']),
      json['isBanned'] as bool,
    );

Map<String, dynamic> _$StageToJson(Stage instance) => <String, dynamic>{
      'stageName': instance.stageName,
      'stageImgPath': instance.stageImgPath,
      'legality': _$LegalityEnumMap[instance.legality],
      'isBanned': instance.isBanned,
    };

const _$LegalityEnumMap = {
  Legality.legal: 'legal',
  Legality.hazardsOn: 'hazardsOn',
  Legality.illegal: 'illegal',
};
