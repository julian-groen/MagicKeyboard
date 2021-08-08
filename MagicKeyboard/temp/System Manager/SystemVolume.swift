//
//  AudioToolbox.swift
//  MagicKeyboard
//
//  Created by Julian Groen on 12/07/2021.
//

import SimplyCoreAudio
import AudioToolbox

class SystemVolume {
    static let shared = SimplyCoreAudio()
}

extension AudioDevice {
    
    public func volumeUp() {
        let incrementSteps = SystemProperties.steps
        if muted { mute(set: false) }
        if let volumeLevel = incrementSteps.first(where: { $0 > volume }) {
            volume(set: volumeLevel)
        }
    }
    
    public func volumeDown() {
        let decrementSteps = SystemProperties.steps.reversed()
        if muted { mute(set: false) }
        if let volumeLevel = decrementSteps.first(where: { $0 < volume }) {
            volume(set: volumeLevel)
        }
    }
    
    public func toggleMute() {
        mute(set: muted ? false : true)
    }
    
    private var volume: Float {
        var obtainedVolume: Float = -1.0
        if let pair: StereoPair = preferredChannelsForStereo(scope: .output) {
            let rV: Float = volume(channel: pair.right, scope: .output) ?? -1.0
            let lV: Float = volume(channel: pair.left , scope: .output) ?? -1.0
            obtainedVolume = (rV + lV) / 2.0
        }

        if obtainedVolume == -1.0 {
            obtainedVolume = volume(channel: kAudioObjectPropertyElementMaster, scope: .output) ?? 0.0
        }
        
        return obtainedVolume
    }
    
    private var muted: Bool {
        var obtainedMuted: Bool = false
        if let pair: StereoPair = preferredChannelsForStereo(scope: .output) {
            let rM: Bool = isMuted(channel: pair.right, scope: .output) ?? false
            let lM: Bool = isMuted(channel: pair.left , scope: .output) ?? false
            obtainedMuted = (rM || lM)
        }

        if obtainedMuted == false {
            obtainedMuted = isMuted(channel: kAudioObjectPropertyElementMaster, scope: .output) ?? false
        }
    
        return obtainedMuted
    }
    
    private func volume(set volume: Float) {
        var didChangeVolume: Bool = false
        
        if let pair: StereoPair = preferredChannelsForStereo(scope: .output) {
            didChangeVolume = (setVolume(volume, channel: pair.right, scope: .output) || didChangeVolume)
            didChangeVolume = (setVolume(volume, channel: pair.left , scope: .output) || didChangeVolume)
        }

        if didChangeVolume == false {
            setVolume(volume, channel: kAudioObjectPropertyElementMaster, scope: .output)
        }
        
        SystemGraphics.shared.showImage(
            OSDGraphicSpeaker,
            onDisplayID: CGMainDisplayID(),
            priority: OSDPriorityDefault,
            msecUntilFade: 1000,
            filledChiclets: Int32(volume * 16),
            totalChiclets: 16,
            locked: false
        )
    }
    
    private func mute(set muted: Bool) {
        var didChangeMuted: Bool = false
        
        if let pair: StereoPair = preferredChannelsForStereo(scope: .output) {
            didChangeMuted = (setMute(muted, channel: pair.right, scope: .output) || didChangeMuted)
            didChangeMuted = (setMute(muted, channel: pair.left , scope: .output) || didChangeMuted)
        }

        if didChangeMuted == false {
            setMute(muted, channel: kAudioObjectPropertyElementMaster, scope: .output)
        }
        
        SystemGraphics.shared.showImage(
            OSDGraphicSpeakerMuted,
            onDisplayID: CGMainDisplayID(),
            priority: OSDPriorityDefault,
            msecUntilFade: 1000
        )

    }
}
