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
    case LittleBombName = "littlebomb.wav"
    case BigBombName = "bigbomb.wav"
    case AttackAudioName = "falling2a.wav"
    case AttackedAudioName = "falling1a.wav"
    case AlertAudioName = "siren1.wav"
    case SetWeaponAudioName = "chooseweapon.wav"
    case Round2Fight = "Round2Fight.wav"
    case PowerUpAudioName = "powerup.wav"
    case ButtonAudioName = "button.wav"
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
