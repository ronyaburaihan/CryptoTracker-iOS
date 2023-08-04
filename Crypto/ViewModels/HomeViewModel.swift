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
    }
 }
