//
//  HapticManager.swift
//  Crypto
//
//  Created by Abu Raihan Rony on 10/8/23.
//

import Foundation
import SwiftUI

class HapticManager {
    
    static private let generator = UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType){
        generator.notificationOccurred(type)
    }
    
}
