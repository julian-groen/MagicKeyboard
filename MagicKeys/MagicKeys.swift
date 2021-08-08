//
//  MagicKeys.swift
//  MagicKeys
//
//  Created by Julian Groen on 03/08/2021.
//

import Cocoa
import Carbon


public protocol MagicKeysDelegate: AnyObject {
    func intercept(key: MagicKey, event: NSEvent?) -> Bool
    func equivalent(key: MagicKey, event: NSEvent?) -> Bool
}

public extension MagicKeysDelegate {
    func equivalent(key: MagicKey, event: NSEvent?) -> Bool { return false }
}

public class MagicKeys {
    
    let internals: InternalEvent
    weak var delegate: MagicKeysDelegate?
    
    public init(delegate: MagicKeysDelegate) {
        self.delegate = delegate
        self.internals = InternalEvent()
    }
    
    public func initialize() {
        internals.delegate = self
        do {
            try internals.registerEventHandler()
        } catch let error as InternalError {
            print(error.description)
        } catch { }
    }
    
    private func riddikulus(_ fn: UInt16) -> MagicKey? {
        switch (Int(fn)) {
        case kVK_F1 : return NX_KEYTYPE_BRIGHTNESS_DOWN
        case kVK_F2 : return NX_KEYTYPE_BRIGHTNESS_UP
        case kVK_F5 : return NX_KEYTYPE_ILLUMINATION_DOWN
        case kVK_F6 : return NX_KEYTYPE_ILLUMINATION_UP
        case kVK_F7 : return NX_KEYTYPE_REWIND
        case kVK_F8 : return NX_KEYTYPE_PLAY
        case kVK_F9 : return NX_KEYTYPE_FAST
        case kVK_F10: return NX_KEYTYPE_MUTE
        case kVK_F11: return NX_KEYTYPE_SOUND_DOWN
        case kVK_F12: return NX_KEYTYPE_SOUND_UP
        default: return nil
        }
    }
}

extension MagicKeys: InternalEventDelegate {
           
    func intercepted(_ event: NSEvent) -> Bool {
        if event.type.rawValue == NX_SYSDEFINED {
            guard let magickey = event.magickey else { return false }
            return delegate?.intercept(key: magickey, event: event) ?? false
        }
        
        guard let magickey = riddikulus(event.keyCode) else { return false }
        
        if (delegate?.equivalent(key: magickey, event: event) ?? false) {
            event.performKeyEquivalent(key: magickey); return true
        }
        return false
    }
}
