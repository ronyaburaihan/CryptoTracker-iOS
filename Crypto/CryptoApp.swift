//
//  CryptoApp.swift
//  Crypto
//
//  Created by Abu Raihan Rony on 31/7/23.
//

import SwiftUI

@main
struct CryptoApp: App {
    
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(viewModel)
        }
    }
}
