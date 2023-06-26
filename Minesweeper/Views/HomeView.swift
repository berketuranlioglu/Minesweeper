//
//  HomeView.swift
//  Minesweeper
//
//  Created by Berke Turanlıoğlu on 25.06.2023.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var gameViewModel: GameViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: GameView(), label: {
                    Text("\(gameViewModel.cells[0].number)")
                })
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
