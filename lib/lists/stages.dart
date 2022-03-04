import 'package:ultimate_counterpicks/rulesets/classes/legality.dart';

import '../rulesets/classes/stage.dart';

enum LegalStagesEnum{
  finalDestination,
  smashville,
  hollowBastion,
  ps2,
  smallBattlefield,
  kalos,
  northernCave,
  battlefield,
  yoshisStory,
  lylat,
  townAndCity,

}

Stage getLegalStage(LegalStagesEnum stage){
  switch(stage){
    case LegalStagesEnum.finalDestination:
      return Stage("Final Destination", "stageImages/hazardsOff/Final_Destination.jpg", Legality.hazardsOn,false);
    case LegalStagesEnum.battlefield:
      return Stage("Battlefield", "stageImages/hazardsOff/Battlefield.png", Legality.hazardsOn,false);
    case LegalStagesEnum.ps2:
      return Stage("PS2","stageImages/hazardsOff/Pokemon_Stadium_2.png",Legality.legal,false);
    case LegalStagesEnum.smashville:
      return Stage("Smashville","stageImages/legal/Smashville.png", Legality.hazardsOn,false);
    case LegalStagesEnum.townAndCity:
      return Stage("Town And City","stageImages/hazardsOff/Town_and_City.png",Legality.hazardsOn,false);
    case LegalStagesEnum.smallBattlefield:
      return Stage("Small Battlefield","stageImages/hazardsOff/Small_Battlefield.jpg",Legality.hazardsOn,false);
    case LegalStagesEnum.kalos:
      return Stage("Kalos","stageImages/legal/Kalos_Pokémon_League.png",Legality.legal,false);
    case LegalStagesEnum.lylat:
      return Stage("Lylat","stageImages/legal/Lylat_Cruise.jpg",Legality.hazardsOn,false);
    case LegalStagesEnum.yoshisStory:
      return Stage("Yoshi's Story","stageImages/hazardsOff/Yoshi's_Story.png",Legality.hazardsOn,false);
    case LegalStagesEnum.hollowBastion:
      return Stage("Hollow Bastion", "stageImages/hazardsOff/Hollow_Bastion.jpg",Legality.hazardsOn,false);
    case LegalStagesEnum.northernCave:
      return Stage("Northern Cave", "stageImages/hazardsOff/Northern_Cave.png",Legality.hazardsOn,false);
  }
}

enum IllegalStagesEnum{
  theGreatCaveOffensive
}

Stage getIllegalStage(IllegalStagesEnum stage){
  switch(stage){
    case IllegalStagesEnum.theGreatCaveOffensive:
      return Stage("The Great Cave Offensive", "stageImages/illegal/The_Great_Cave_Offensive.png", Legality.illegal,false);
  }
}