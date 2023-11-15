import 'package:ultimate_counterpicks/lists/stages.dart';
import 'package:ultimate_counterpicks/rulesets/classes/legality.dart';
import 'package:ultimate_counterpicks/rulesets/classes/ruleset.dart';

class DefaultRulesets {
  List<Ruleset> rulesets = [
    //Genesis 8
    Ruleset(
        -1,
        "Gensis 8",
        //Starters
        [
          getLegalStage(LegalStagesEnum.battlefield),
          getLegalStage(LegalStagesEnum.finalDestination),
          getLegalStage(LegalStagesEnum.townAndCity),
          getLegalStage(LegalStagesEnum.ps2),
          getLegalStage(LegalStagesEnum.smashville)
        ],
        //Counterpicks
        [
          getLegalStage(LegalStagesEnum.kalos),
          getLegalStage(LegalStagesEnum.smallBattlefield)
        ],
        Legality.legal),

    //Genesis 9
    Ruleset(
        -1,
        "Genesis 9",
        //Starters
        [
          getLegalStage(LegalStagesEnum.battlefield),
          getLegalStage(LegalStagesEnum.smallBattlefield),
          getLegalStage(LegalStagesEnum.ps2),
          getLegalStage(LegalStagesEnum.smashville),
          getLegalStage(LegalStagesEnum.townAndCity)
        ],
        //Counterpicks
        [
          getLegalStage(LegalStagesEnum.finalDestination),
          getLegalStage(LegalStagesEnum.kalos),
          getLegalStage(LegalStagesEnum.lylat)
        ],
        Legality.legal),

    //Coinbox
    Ruleset(
        -1,
        "Coinbox",
        //Starters
        [
          getLegalStage(LegalStagesEnum.battlefield),
          getLegalStage(LegalStagesEnum.finalDestination),
          getLegalStage(LegalStagesEnum.townAndCity),
          getLegalStage(LegalStagesEnum.ps2),
          getLegalStage(LegalStagesEnum.smashville),
        ],
        //Counterpicks
        [
          getLegalStage(LegalStagesEnum.kalos),
          getLegalStage(LegalStagesEnum.smallBattlefield),
          getLegalStage(LegalStagesEnum.yoshisStory)
        ],
        Legality.legal),

    //Dreamhack atlanta 2023
    Ruleset(
        -1,
        "DreamHack Atlanta 2023",
        //Starters
        [
          getLegalStage(LegalStagesEnum.battlefield),
          getLegalStage(LegalStagesEnum.smallBattlefield),
          getLegalStage(LegalStagesEnum.ps2),
          getLegalStage(LegalStagesEnum.smashville),
          getLegalStage(LegalStagesEnum.townAndCity)
        ],
        //Counterpicks
        [
          getLegalStage(LegalStagesEnum.hollowBastion),
          getLegalStage(LegalStagesEnum.kalos),
          getLegalStage(LegalStagesEnum.finalDestination)
        ],
        Legality.legal),

    //Collision 2023
    Ruleset(
        -1,
        "Collision 2024",
        //Starters
        [
          getLegalStage(LegalStagesEnum.battlefield),
          getLegalStage(LegalStagesEnum.finalDestination),
          getLegalStage(LegalStagesEnum.smallBattlefield),
          getLegalStage(LegalStagesEnum.ps2),
          getLegalStage(LegalStagesEnum.smashville)
        ],
        //Counterpicks
        [
          getLegalStage(LegalStagesEnum.townAndCity),
          getLegalStage(LegalStagesEnum.hollowBastion)
        ],
        Legality.legal)
  ];
}
