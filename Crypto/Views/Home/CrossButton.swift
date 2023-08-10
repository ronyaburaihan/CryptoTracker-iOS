//
//  CrossButton.swift
//  Crypto
//
//  Created by Abu Raihan Rony on 8/8/23.
//

import SwiftUI

struct CrossButton: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button (action: {
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            Image (systemName: "xmark")
        })
    }
}

struct CrossButton_Previews: PreviewProvider {
    static var previews: some View {
        CrossButton()
    }
}
