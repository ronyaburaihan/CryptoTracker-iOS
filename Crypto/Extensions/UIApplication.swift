//
//  UIApplication.swift
//  Crypto
//
//  Created by Abu Raihan Rony on 4/8/23.
//

import Foundation
import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
