//
//  SettingsView.swift
//  Crypto
//
//  Created by Abu Raihan Rony on 16/10/23.
//

import SwiftUI

struct SettingsView: View {
    
    let defaultUrl = URL(string: "https://www.google.com")!
    let coffeUrl = URL(string: "https://www.buymeacoffee.com/ronyaburaihan")!
    let coingekoURL = URL(string: "https://www.coingecko.com")!
    
    var body: some View {
        NavigationView {
            ZStack {
                // background
                Color.theme.background.ignoresSafeArea()
                
                // content
                List {
                    cryptoTrackerSection
                        .listRowBackground(Color.clear)
                     coinGeckoSection
                        .listRowBackground(Color.clear)
                }
                .font(.headline)
                .accentColor(.blue)
                .listStyle(GroupedListStyle())
                .navigationTitle("Settings")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        CrossButton()
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}

extension SettingsView {
    
    private var cryptoTrackerSection: some View {
        Section(header: Text("Crypto tracker")) {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
                
            }
            .padding(.vertical)
            
            Link("Google", destination: defaultUrl)
            Link("Buy me a coffee", destination: coffeUrl)
        }
    }
    
    private var coinGeckoSection: some View {
        Section(header: Text("CoinGecko")) {
            VStack(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
                
            }
            .padding(.vertical)
            
            Link("Visit CoinGecko", destination: coingekoURL)
            Link("Buy me a coffee", destination: coffeUrl)
        }
    }
}
