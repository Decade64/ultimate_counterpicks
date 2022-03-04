import 'package:ultimate_counterpicks/lists/stages.dart';
import 'package:ultimate_counterpicks/rulesets/classes/legality.dart';
import 'package:ultimate_counterpicks/rulesets/classes/ruleset.dart';


List<Ruleset> basicRulesets = [
  Ruleset(
      0,
      "Basic",
      [
        getLegalStage(LegalStagesEnum.finalDestination),
      ],
      [
        getLegalStage(LegalStagesEnum.battlefield)
      ],
      Legality.legal
  )
];