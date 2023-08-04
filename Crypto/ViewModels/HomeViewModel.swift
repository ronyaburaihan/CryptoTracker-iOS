//
//  HomeViewModel.swift
//  Crypto
//
//  Created by Abu Raihan Rony on 1/8/23.
//

import Foundation
import Combine


class HomeViewModel: ObservableObject {
    
    @Published var coinList: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    @Published var searchText: String = ""
    
    private let dataService = CoinDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init () {
        addSubscriber()
    }
    
    func addSubscriber() {
        dataService.$allCoinList
            .sink { [weak self] (returenedCoins) in
                self?.coinList = returenedCoins
            }
            .store(in: &cancellables)
        
        $searchText
            .combineLatest(dataService.$allCoinList)
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .map(filterCoins) 
            .sink { [weak self] (returnedCoins) in
                self?.coinList = returnedCoins
            }.store(in: &cancellables)
        
    }
    
    private func filterCoins(text: String, coins: [Coin]) -> [Coin] {
        
        guard !text.isEmpty else {
            return coins
        }
        
        let lowercasedText = text.lowercased()
        return coins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowercasedText) ||
            coin.symbol.lowercased().contains(lowercasedText) ||
            coin.id.lowercased().contains(lowercasedText)
        }
        
    }
 }
