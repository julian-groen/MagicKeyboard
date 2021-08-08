//
//  InternalEvent.swift
//  MagicKeys
//
//  Created by Julian Groen on 03/08/2021.
//

import Cocoa


typealias EventCallback = @convention(block) (CGEventType, CGEvent) -> CGEvent?

class InternalEvent {

    var runLoopQueue: DispatchQueue?
    var runLoopCurrent: CFRunLoop?
    var runLoopSource: CFRunLoopSource?
    var keyboardEventPort: CFMachPort?
    var eventCallback: EventCallback?

    weak var delegate: InternalEventDelegate?
    
    func enableEventHandler(enabled: Bool) {
        if keyboardEventPort != nil, let runLoop = runLoopCurrent {
            let commonMode: CFRunLoopMode = CFRunLoopMode.commonModes
            CFRunLoopPerformBlock(runLoop, commonMode as CFTypeRef) { [weak self] in
                guard let port = self?.keyboardEventPort else { return }
                CGEvent.tapEnable(tap: port, enable: enabled)
            }
            CFRunLoopWakeUp(runLoop)
        }
    }
    
    func registerEventHandler() throws {
        let callback: EventCallback = { [weak self] type, event in
            if type == .tapDisabledByTimeout {
                if let port = self?.keyboardEventPort {
                    CGEvent.tapEnable(tap: port, enable: true)
                }
                return event
            }
            return DispatchQueue.main.sync {
                self?.manipulateInterceptedEvent(event, of: type)
            }
        }

        self.enableEventHandler(enabled: true)
        try constructEventHandler(callback: callback)
        self.eventCallback = callback
    }
    
    func constructEventHandler(callback: @escaping EventCallback) throws {
        keyboardEventPort = keysCaptureEventPort(callback: callback)
        guard let port = keyboardEventPort else { throw InternalError.eventTapCreationFailure }

        runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorSystemDefault, port, 0)
        guard let source = runLoopSource else { throw InternalError.runLoopSourceCreationFailure }
        
        runLoopQueue = DispatchQueue(label: "MagicKeyboard Runloop", attributes: [])
        runLoopQueue?.async { [weak self] in
            self?.runLoopCurrent = CFRunLoopGetCurrent()
            CFRunLoopAddSource(self?.runLoopCurrent, source, CFRunLoopMode.commonModes)
            CFRunLoopRun()
        }
    }
    
    func keysCaptureEventPort(callback: @escaping EventCallback) -> CFMachPort? {
        let refcon = unsafeBitCast(callback, to: UnsafeMutableRawPointer.self)
        let interest = CGEventMask(1 << NX_KEYDOWN | 1 << NX_KEYUP | 1 << NX_SYSDEFINED)
        let callback: CGEventTapCallBack = { _, type, event, refcon in
            let innerBlock = unsafeBitCast(refcon, to: EventCallback.self)
            return innerBlock(type, event).map(Unmanaged.passUnretained)
        }
        return CGEvent.tapCreate(tap: .cgSessionEventTap, place: .headInsertEventTap, options:
            .defaultTap, eventsOfInterest: interest, callback: callback, userInfo: refcon)
    }
    
    func unregisterEventHandler() {
        if let runLoopSource = self.runLoopSource {
            CFRunLoopSourceInvalidate(runLoopSource)
        }
        if let keyboardEventPort = self.keyboardEventPort {
            CFMachPortInvalidate(keyboardEventPort)
        }
        if let runLoopCurrent = self.runLoopCurrent {
            CFRunLoopStop(runLoopCurrent)
        }
    }
    
    func manipulateInterceptedEvent(_ event: CGEvent, of type: CGEventType) -> CGEvent? {
        if let _event = NSEvent(cgEvent: event) {
            return (delegate?.intercepted(_event) ?? false) ? nil : event
        }
        return event
    }
    
    deinit { self.unregisterEventHandler() }
}

protocol InternalEventDelegate: AnyObject {
    func intercepted(_ event: NSEvent) -> Bool
}

enum InternalError: Error, CustomStringConvertible {

    case eventTapCreationFailure
    case runLoopSourceCreationFailure

    var description: String {
        switch self {
        case .eventTapCreationFailure:
            return "Event tap creation failed: is your application sandboxed?"
        case .runLoopSourceCreationFailure:
            return "Runloop source creation failed"
        }
    }
}
