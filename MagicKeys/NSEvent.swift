//
//  NSEvent.swift
//  MagicKeys
//
//  Created by Julian Groen on 05/08/2021.
//

import Cocoa


public typealias MagicKey = Int32

extension NSEvent {
    
    var magickey: MagicKey? {
        return (subtype.rawValue == 8 ? MagicKey((data1 & 0xFFFF_0000) >> 16) : nil)
    }
    
    func performKeyEquivalent(key: Int32) {
        let data  = Int((key << 16) | (type == .keyDown ? 0xa00 : 0xb00) + (isARepeat ? 1 : 0))
        let event = NSEvent.otherEvent(with: .systemDefined, location: locationInWindow, modifierFlags: modifierFlags,
                timestamp: timestamp, windowNumber: windowNumber, context: nil, subtype: 8, data1: data, data2: -1)
        event?.cgEvent?.post(tap: .cghidEventTap)
    }
}
