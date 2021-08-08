//
//  OSDManager.swift
//  MagicKeyboard
//
//  Created by Julian Groen on 18/07/2021.
//

import Foundation


extension OSDManager {
    
    func showImage(_ image: OSDGraphic) {
        OSDUtil.shared.showImage(image, onDisplayID: CGMainDisplayID(), priority: OSDPriorityDefault, msecUntilFade: 1000)
    }
    
    func showImage(_ image: OSDGraphic, filledChiclets filled: Int32) {
        OSDUtil.shared.showImage(image, onDisplayID: CGMainDisplayID(), priority: OSDPriorityDefault, msecUntilFade: 1000, filledChiclets: filled, totalChiclets: 64, locked: false)
    }
}
