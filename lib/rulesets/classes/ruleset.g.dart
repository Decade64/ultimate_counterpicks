// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ruleset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ruleset _$RulesetFromJson(Map<String, dynamic> json) => Ruleset(
      json['id'] as int,
      json['name'] as String,
      (json['starters'] as List<dynamic>)
          .map((e) => Stage.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['counterpicks'] as List<dynamic>)
          .map((e) => Stage.fromJson(e as Map<String, dynamic>))
          .toList(),
      $enumDecode(_$LegalityEnumMap, json['legality']),
    );

Map<String, dynamic> _$RulesetToJson(Ruleset instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'starters': instance.starters.map((e) => e.toJson()).toList(),
      'counterpicks': instance.counterpicks.map((e) => e.toJson()).toList(),
      'legality': _$LegalityEnumMap[instance.legality],
    };

const _$LegalityEnumMap = {
  Legality.legal: 'legal',
  Legality.hazardsOn: 'hazardsOn',
  Legality.illegal: 'illegal',
};
