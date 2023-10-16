//
//  String.swift
//  Crypto
//
//  Created by Abu Raihan Rony on 16/10/23.
//

import Foundation
import SwiftUI

extension String {
    
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
