//
//  HomeViewModel.swift
//  Crypto
//
//  Created by Abu Raihan Rony on 1/8/23.
//

import Foundation
import Combine


class HomeViewModel: ObservableObject {
    
    @Published var statistics : [StatisticModel] = []
    
    @Published var coinList: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var sortOption: SortOption = .holdings
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOption {
        case rank, rankReversed, holdings, holdingReversed, price, priceReversed
    }
    
    init () {
        addSubscriber()
    }
    
    func addSubscriber() {
       
        // updated all coins
        $searchText
            .combineLatest(coinDataService.$allCoinList, $sortOption)
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] (returnedCoins) in
                self?.coinList = returnedCoins
            }.store(in: &cancellables)
        
        // update market data
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] (returnedStats) in
                self?.statistics = returnedStats
                self?.isLoading = false
            }
            .store(in: &cancellables)
        
        // update portfolio data
        $coinList
            .combineLatest(portfolioDataService.$savedEntities)
            .map { (coinModels, portfolioEntities) -> [Coin] in
                coinModels.compactMap { (coin)  -> Coin? in
                    guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id }) else {
                        return nil
                    }
                    return coin.updateHoldings(amount: entity.amount)
                }
            }
            .sink { [weak self] (returnedCoin) in
                guard let self = self else { return }
                self.portfolioCoins = self.sortPortfilioCoinIfNeeded(coins: returnedCoin)
            }
            .store(in: &cancellables)
        
    }
    
    func updatePortfolio(coin: Coin, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData() {
        isLoading = true
        coinDataService.getData()
        marketDataService.getData()
        HapticManager.notification(type: .success)
    }
    
    private func filterAndSortCoins(text: String, coins: [Coin], sort: SortOption) -> [Coin] {
        var updatedCoins = filterCoins(text: text, coins: coins)
        sortCoins(sort: sort, coins: &updatedCoins)
        return updatedCoins
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
    
    private func sortCoins(sort: SortOption, coins: inout [Coin]) {
        switch sort {
        case .rank, .holdings:
            coins.sort { $0.rank < $1.rank }
        case .rankReversed, .holdingReversed:
            coins.sort { $0.rank > $1.rank }
        case .price:
            coins.sort { $0.currentPrice > $1.currentPrice }
        case .priceReversed:
            coins.sort { $0.currentPrice < $1.currentPrice }
        }
    }
    
    private func sortPortfilioCoinIfNeeded(coins: [Coin]) -> [Coin] {
        switch sortOption {
        case .holdings:
            return coins.sorted { $0.currentHoldingValue > $1.currentHoldingValue}
        case .holdingReversed:
            return coins.sorted { $0.currentHoldingValue < $1.currentHoldingValue}
        default:
            return coins
        }
    }
    
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?, portfolioCoins: [Coin]) -> [StatisticModel] {
        var stats: [StatisticModel] = []
        
        guard let data = marketDataModel else {
            return stats
        }
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        
        let portfolioValue = portfolioCoins.map { $0.currentHoldingValue }
            .reduce(0, +)
        
        let previousValue = portfolioCoins.map { (coin) -> Double in
            let currentValue = coin.currentHoldingValue
            let percentChange = (coin.priceChangePercentage24H ?? 0) / 100
            
            let previousValue = currentValue / (1 + percentChange)
            return previousValue
        }.reduce(0, +)
        
        let percentChange = ((portfolioValue - previousValue) / previousValue) * 100
        
        let portfolio = StatisticModel(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Deciamls(), percentageChange: percentChange)
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        
        return stats
    }
 }
