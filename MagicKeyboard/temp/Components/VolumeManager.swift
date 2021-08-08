//
//  VolumeManager.swift
//  MagicKeyboard
//
//  Created by Julian Groen on 15/07/2021.
//

import Cocoa
import AVFoundation
import SimplyCoreAudio
import Carbon


//class VolumeManager {
//    
//    public static let shared = VolumeManager()
//    
//    private var audioPlayer: AVAudioPlayer?
//    private let coreAudio = SimplyCoreAudio()
//    
//    public func register() {
//        MagicKey(keyCode: kVK_F10, modifiers: [], function: toggleVolumeMute)
//        MagicKey(keyCode: kVK_F11, modifiers: [], function: largeVolumeDecrease)
//        MagicKey(keyCode: kVK_F12, modifiers: [], function: largeVolumeIncrease)
//        
//        MagicKey(keyCode: kVK_F11, modifiers: [.option, .shift], function: smallVolumeDecrease)
//        MagicKey(keyCode: kVK_F12, modifiers: [.option, .shift], function: smallVolumeIncrease)
//        
//        MagicKey(keyCode: kVK_F10, modifiers: [.option], function: launchPreferences)
//        MagicKey(keyCode: kVK_F11, modifiers: [.option], function: launchPreferences)
//        MagicKey(keyCode: kVK_F12, modifiers: [.option], function: launchPreferences)
//    }
//    
//    private func launchPreferences(_ type: NSEvent.EventType) {
//        guard type == .keyDown else { return }
//        LaunchApplication("/System/Library/PreferencePanes/Sound.prefPane")
//    }
//    
//    private func toggleVolumeMute(_ type: NSEvent.EventType) {
//        guard type == .keyDown else { return }
//        coreAudio.defaultOutputDevice?.toggleVolumeMute()
//        playFeedbackSound(); showFeedbackSound()
//    }
//    
//    private func smallVolumeIncrease(_ type: NSEvent.EventType) {
//        if type == .keyDown {
//            coreAudio.defaultOutputDevice?.volume(increaseWith: Array(systemSmallPiclets))
//            showFeedbackSound()
//        } else if type == .keyUp { playFeedbackSound() }
//    }
//    
//    private func largeVolumeIncrease(_ type: NSEvent.EventType) {
//        if type == .keyDown {
//            coreAudio.defaultOutputDevice?.volume(increaseWith: Array(systemLargePiclets))
//            showFeedbackSound()
//        } else if type == .keyUp { playFeedbackSound() }
//    }
//    
//    private func smallVolumeDecrease(_ type: NSEvent.EventType) {
//        if type == .keyDown {
//            coreAudio.defaultOutputDevice?.volume(decreaseWith: systemSmallPiclets.reversed())
//            showFeedbackSound()
//        } else if type == .keyUp { playFeedbackSound() }
//    }
//    
//    private func largeVolumeDecrease(_ type: NSEvent.EventType) {
//        if type == .keyDown {
//            coreAudio.defaultOutputDevice?.volume(decreaseWith: systemLargePiclets.reversed())
//            showFeedbackSound()
//        } else if type == .keyUp { playFeedbackSound() }
//    }
//    
//    private func playFeedbackSound() {
//        let path = "/System/Library/LoginPlugins/BezelServices.loginPlugin/Contents/Resources/volume.aiff"
//        self.audioPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
//        self.audioPlayer?.prepareToPlay() ?? false ? _ = self.audioPlayer?.play() : nil
//    }
//    
//    private func showFeedbackSound() {
//        guard let device = coreAudio.defaultOutputDevice else { return }
//        if device.muted == false && device.volume > 0.0 {
//            OSDUtil.shared.showImage(OSDGraphicSpeaker, filledChiclets: Int32(device.volume * 64))
//        } else {
//            OSDUtil.shared.showImage(OSDGraphicSpeakerMuted)
//        }
//    }
//}
