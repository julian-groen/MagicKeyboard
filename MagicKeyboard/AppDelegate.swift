//
//  AppDelegate.swift
//  MagicKeyboard
//
//  Created by Julian Groen on 12/07/2021.
//

import AppKit
import MagicKeys
import Carbon


class AppDelegate: NSObject, NSApplicationDelegate {
    
    var magicKeys: MagicKeys?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.magicKeys = MagicKeys(delegate: self)
        self.magicKeys?.initialize()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

extension AppDelegate: MagicKeysDelegate {
    func intercept(key: MagicKey, event: NSEvent?) -> Bool { return false }
    func equivalent(key: MagicKey, event: NSEvent?) -> Bool { return true }
}
