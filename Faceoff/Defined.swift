//
//  Defined.swift
//  Faceoff
//
//  Created by Sunny Chiu on 9/29/15.
//  Copyright © 2015 huaying. All rights reserved.
//

import Foundation
import CoreGraphics

let DefinedScreenWidth:CGFloat = 1536
let DefinedScreenHeight:CGFloat = 2048

enum FaceoffGameSceneChildName : String {
    case HeroName = "hero"
    case RivalName = "rival"
    case SelectedWeaponName = "selectedweapon"
    case HPName = "hp"
    case MPName = "mp"
    case ScoreName = "score"
    case TipName = "tip"
    case GameOverLayerName = "over"
    case RetryButtonName = "retry"
    case HighScoreName = "highscore"
}

enum FaceoffGameSceneActionKey: String {
    case AttackAction = "attack"
    case DefenceAction = "defence"
    case StickGrowAudioAction = "stick_grow_audio"
    case PowerUpAction = "powerup"
    case HeroScaleAction = "hero_scale"
}

enum FaceoffGameSceneEffectAudioName: String {
    case LittleBombName = "littlebomb.mp3"
    case BigBombName = "bigbomb.mp3"
    case AttackAudioName = "falling2a.mp3"
    case AttackedAudioName = "falling1a.mp3"
    case AlertAudioName = "siren1.mp3"
    case SetWeaponAudioName = "chooseweapon.mp3"
    case Round2Fight = "Round2Fight.mp3"
    case PowerUpAudioName = "powerup.mp3"
    case ButtonAudioName = "button.mp3"
}

//enum FaceoffScreenCrashEffectAudioName: String {
//    case Crash1 = "crush.png"
//    case Crash2 = "crush2.png"
//    case Crash3 = "crush3.png"
//    case Crash4 = "crush4.png"
//}

enum FaceoffGameSceneZposition: CGFloat {
    case BackgroundZposition = -1
    case StackZposition = 30
    case StackMidZposition = 35
    case StickZposition = 40
    case ScoreBackgroundZposition = 50
    case HeroZposition, ScoreZposition, TipZposition, PerfectZposition = 100
    case EmitterZposition
    case GameOverZposition
}
