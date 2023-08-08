//
//  HomeView.swift
//  Crypto
//
//  Created by Abu Raihan Rony on 1/8/23.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var viewModel: HomeViewModel
    @State private var showPortfolio: Bool = false  // animate right
    @State private var showPortfolioView: Bool = false // new sheet
    
    var body: some View {
        ZStack {
            
            //background layer
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView){
                    PortfolioView()
                        .environmentObject(viewModel)
                }
            
            //content layer
            VStack {
                homeHeader
                
                HomeStatsView(showPortfolio: $showPortfolio)
                
                SearchBarView(searchText: $viewModel.searchText)
                
                columnTitles
                
                if !showPortfolio {
                    allCoinList
                    .transition(.move(edge: .leading))
                }
                
                if showPortfolio {
                    portfolioCoinList
                        .transition(.move(edge: .trailing))
                }
                
                Spacer(minLength: 0)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .navigationBarHidden(true)
        }.environmentObject(dev.homeViewModel)
    }
}

extension HomeView {
    
    private var homeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(.none)
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
                    }
                }
                .background(CircleButtonAnimation(animate: $showPortfolio))
            
            Spacer()
            
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
                .animation(.none)
            
            Spacer()
            
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    
    private var allCoinList: some View {
        List {
            ForEach(viewModel.coinList) { coin in
                CoinItemView(coin: coin, showHoldingColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var portfolioCoinList: some View {
        List {
            ForEach(viewModel.portfolioCoins) { coin in
                CoinItemView(coin: DeveloperPreview.instance.coin, showHoldingColumn: showPortfolio)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var columnTitles: some View {
        HStack {
            Text("Coin")
            Spacer()
            if showPortfolio {
                Text("Holding")
            }
            Text("Price")
                .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }
    
}
