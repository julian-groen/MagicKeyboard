//
//  LaunchApplication.swift
//  MagicKeyboard
//
//  Created by Julian Groen on 15/07/2021.
//

import Cocoa


func LaunchApplication(_ url: String) {
    NSWorkspace.shared.open(URL(fileURLWithPath: url))
}
