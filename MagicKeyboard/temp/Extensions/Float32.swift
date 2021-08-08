//
//  Float32.swift
//  MagicKeyboard
//
//  Created by Julian Groen on 17/07/2021.
//

import Foundation


extension Float32 {
    func roundTo(places: Int) -> Float {
        let divisor = pow(10.0, Float32(places)); return (self * divisor).rounded() / divisor
    }
}
