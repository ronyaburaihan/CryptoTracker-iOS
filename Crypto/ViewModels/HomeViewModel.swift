//
//  HomeViewModel.swift
//  Crypto
//
//  Created by Abu Raihan Rony on 1/8/23.
//

import Foundation

class HomeViewModel: ObservableObject {
    
    @Published var coinList: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    
    init () {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            self.coinList.append(DeveloperPreview.instance.coin)
            self.portfolioCoins.append(DeveloperPreview.instance.coin)
        }
    }
}
