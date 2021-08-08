//
//  MagicKeyManager.swift
//  MagicKeyboard
//
//  A wrapper around the C APIs required for a CGEventTap (based on MediaKeyTap)
//
//  Created by Julian Groen on 14/07/2021.
//

import Foundation
import AppKit
import Carbon


typealias EventCallback = @convention(block) (CGEventType, CGEvent) -> CGEvent?

public class MagicKeyboardManager {
    
    var runLoop: CFRunLoop?
    var runLoopSource: CFRunLoopSource?
    var keyboardEventPort: CFMachPort?
    
    weak var delegate: MagicKeyboardDelegate?
    
    func restartEventHandler() throws {
        unregisterEventHandler()
        try registerEventHandler()
    }
    
    func unregisterEventHandler() { }
    
    func registerEventHandler() throws {
        let eventCallback: EventCallback = { [weak self] type, event in
            print(event)
            return event
        }
        
        keyboardEventPort = keyboardEventTapPort(callback: eventCallback)
        guard let port = keyboardEventPort else { throw EventError.eventTapCreationFailure }
        
        runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorSystemDefault, port, 0)
        guard let source = runLoopSource else { throw EventError.runLoopSourceCreationFailure }
        
        let dispatchQueue = DispatchQueue(label: "MagicKeyboard Runloop")
        dispatchQueue.async { [weak self] in
            guard let self = self else { return }
            self.runLoop = CFRunLoopGetCurrent()
            CFRunLoopAddSource(self.runLoop, source, CFRunLoopMode.commonModes)
            CFRunLoopRun()
            print("test")
        }
    }
    
    func keyboardEventTapPort(callback: @escaping EventCallback) -> CFMachPort? {
        let eventCallback: CGEventTapCallBack = { _, type, event, refcon in
            let innerBlock = unsafeBitCast(refcon, to: EventCallback.self)
            return innerBlock(type, event).map(Unmanaged.passUnretained)
        }
        
        let refcon = unsafeBitCast(callback, to: UnsafeMutableRawPointer.self)
        let interest = CGEventMask(NX_KEYDOWNMASK | NX_KEYUPMASK | NX_SYSDEFINED)
        
        return CGEvent.tapCreate(tap: .cgSessionEventTap, place: .headInsertEventTap, options:
            .defaultTap, eventsOfInterest: interest, callback: eventCallback, userInfo: refcon)
    }
}

public protocol MagicKeyboardDelegate: AnyObject {
    // return bool if should override standard
    func handleEvent() -> Bool
}

enum EventError: Error, CustomStringConvertible {
    
    case eventTapCreationFailure
    case runLoopSourceCreationFailure
    
    var description: String {
        switch self {
        case .eventTapCreationFailure: return "Event tap creation failed: is your application sandboxed?"
        case .runLoopSourceCreationFailure: return "Runloop source creation failed"
        }
    }
}


class MagicKeyManager {
    
    private static var keyboardEventTap: CFMachPort?
    private static var magicKeys: [MagicKey] = [MagicKey]()
    
    private static let callback: CGEventTapCallBack = { _, type, event, _ in
        if let tap = keyboardEventTap, type == .tapDisabledByTimeout {
            CGEvent.tapEnable(tap: tap, enable: true)
        }
        return MagicKeyManager.handleEventCallback(event: event, type: type)
    }
    
    static func handleEventCallback(event: CGEvent, type: CGEventType) -> Unmanaged<CGEvent>? {
        guard let keyEvent = NSEvent(cgEvent: event) else {
            return Unmanaged.passRetained(event)
        }
        let didExecute = magicKeys.first(where: { $0.execute(keyEvent) }) != nil
        return didExecute ? nil : Unmanaged.passRetained(event)
    }
    
    static func register(_ magicKey: MagicKey) {
        if magicKeys.contains(magicKey) == false {
            magicKeys.append(magicKey)
        }
        if keyboardEventTap == nil { registerEventHandler() }
    }

    static func unregister(_ magicKey: MagicKey) {
        if let index = magicKeys.firstIndex(of: magicKey) {
            magicKeys.remove(at: index)
        }
    }
    
    static func registerEventHandler() {
        let interested = CGEventMask(NX_KEYDOWNMASK | NX_KEYUPMASK)
        keyboardEventTap = CGEvent.tapCreate(tap: .cgSessionEventTap, place: .headInsertEventTap,
            options: .defaultTap, eventsOfInterest: interested, callback: callback, userInfo: nil)
        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, keyboardEventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: keyboardEventTap!, enable: true)
    }
}
