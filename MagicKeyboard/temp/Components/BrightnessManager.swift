//
//  BrightnessManager.swift
//  MagicKeyboard
//
//  Created by Julian Groen on 15/07/2021.
//

import Cocoa
import Carbon


//class BrightnessManager {
//    
//    public static let shared = BrightnessManager()
//    
//    public func register() {
//        MagicKey(keyCode: kVK_F1, modifiers: [], function: largeBrightnessDecrease)
//        MagicKey(keyCode: kVK_F2, modifiers: [], function: largeBrightnessIncrease)
//
//        MagicKey(keyCode: kVK_F1, modifiers: [.option, .shift], function: smallBrightnessDecrease)
//        MagicKey(keyCode: kVK_F2, modifiers: [.option, .shift], function: smallBrightnessIncrease)
//        
//        MagicKey(keyCode: kVK_F1, modifiers: [.option], function: launchPreferences)
//        MagicKey(keyCode: kVK_F2, modifiers: [.option], function: launchPreferences)
//    }
//    
//    private func launchPreferences(_ type: NSEvent.EventType) {
//        guard type == .keyDown else { return }
//        LaunchApplication("/System/Library/PreferencePanes/Displays.prefPane")
//    }
//    
//    private func smallBrightnessIncrease(_ type: NSEvent.EventType) { }
//    
//    private func largeBrightnessIncrease(_ type: NSEvent.EventType) {
//        
//        showFeedbackBrightness()
//    }
//    
//    private func smallBrightnessDecrease(_ type: NSEvent.EventType) { }
//    
//    private func largeBrightnessDecrease(_ type: NSEvent.EventType) { showFeedbackBrightness() }
//    
//    private func showFeedbackBrightness() {
//        OSDUtil.shared.showImage(OSDGraphicBacklight, filledChiclets: Int32(0.5 * 64))
//    }
//}
