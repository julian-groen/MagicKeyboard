//
//  AudioDevice.swift
//  MagicKeyboard
//
//  Created by Julian Groen on 17/07/2021.
//

import Cocoa
import AVFoundation
import SimplyCoreAudio
import Carbon


extension AudioDevice {
 
    public var volume: Float {
        var obtainedVolume: Float = -1.0
        if let pair: StereoPair = preferredChannelsForStereo(scope: .output) {
            let rV: Float = volume(channel: pair.right, scope: .output) ?? -1.0
            let lV: Float = volume(channel: pair.left , scope: .output) ?? -1.0
            obtainedVolume = (rV + lV) / 2.0
        }

        if obtainedVolume == -1.0 {
            obtainedVolume = volume(channel: kAudioObjectPropertyElementMaster, scope: .output) ?? 0.0
        }

        return obtainedVolume.roundTo(places: 6)
    }

    public var muted: Bool {
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

    public func volume(increaseWith increment: Array<Float>) {
        if let volumeLevel = increment.first(where: { $0.roundTo(places: 6) > volume }) {
            volume(set: volumeLevel.roundTo(places: 6)); mute(set: false)
        }
    }
    
    public func volume(decreaseWith decrement: Array<Float>) {
        if let volumeLevel = decrement.first(where: { $0.roundTo(places: 6) < volume }) {
            volume(set: volumeLevel.roundTo(places: 6)); mute(set: false)
        }
    }

    public func toggleVolumeMute() { mute(set: muted ? false : true) }

    private func volume(set volume: Float) {
        var didChangeVolume: Bool = false

        if let pair: StereoPair = preferredChannelsForStereo(scope: .output) {
            didChangeVolume = (setVolume(volume, channel: pair.right, scope: .output) || didChangeVolume)
            didChangeVolume = (setVolume(volume, channel: pair.left , scope: .output) || didChangeVolume)
        }

        if didChangeVolume == false {
            setVolume(volume, channel: kAudioObjectPropertyElementMaster, scope: .output)
        }
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
    }
}

