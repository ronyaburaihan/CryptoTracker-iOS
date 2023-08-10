//
//  CoinDataService.swift
//  Crypto
//
//  Created by Abu Raihan Rony on 1/8/23.
//

import Foundation
import Combine

class CoinDataService {
    
    @Published var allCoinList: [Coin] = []
    
    var coinSubscription: AnyCancellable?
    
    init() {
        getData()
    }
    
    func getData() {
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else { return }
        
        coinSubscription = NetworkManager.loadDataFromAPI(url: url)
            .decode(type: [Coin].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] (returnedCoins) in
                self?.allCoinList = returnedCoins
                self?.coinSubscription?.cancel()
             })
        
    }
    
}
