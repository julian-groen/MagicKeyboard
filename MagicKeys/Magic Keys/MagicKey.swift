//
//  MagicKey.swift
//  MagicKeyboard
//
//  Created by Julian Groen on 14/07/2021.
//

import Foundation
import AppKit


//class MagicKey: Equatable {
//
//    public typealias Function = (_ event: NSEvent) -> Void
//    
//    public let keyCode: Int
//    public var modifierFlags: NSEvent.ModifierFlags
//    public var function: Function?
//    
//    @discardableResult
//    init(keyCode: Int, modifiers: NSEvent.ModifierFlags = [], function: Function?) {
//        self.keyCode = keyCode
//        self.modifierFlags = modifiers
//        self.function = function
//        MagicKeyManager.register(self)
//    }
//    
//    func execute(_ event: NSEvent) -> Bool {
//        var flags = event.modifierFlags; flags.subtract(.function) // remove function mask
//        let matchingFlags = flags.intersection(.deviceIndependentFlagsMask) == modifierFlags
//        return event.keyCode == keyCode && matchingFlags ? ((function?(event)) != nil) : false
//    }
//    
//    static func ==(lhs: MagicKey, rhs: MagicKey) -> Bool {
//        return lhs.keyCode == rhs.keyCode && lhs.modifierFlags == rhs.modifierFlags
//    }
//}
