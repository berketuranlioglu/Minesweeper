//
//  HomeView.swift
//  Minesweeper
//
//  Created by Berke Turanlıoğlu on 25.06.2023.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var gameViewModel: GameViewModel
    
    @State private var selectedNum = 48
    let numOfMinesList = [24, 36, 48, 60]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                NavigationLink(destination: GameView(numOfMines: selectedNum, remainingFlags: selectedNum)
                    .navigationBarBackButtonHidden(true), label: {
                    Text("Begin game")
                            .font(.custom("Retro Gaming", size: 20))
                })
                .padding(.all)
                
                HStack {
                    Text("How many mines?")
                        .font(.custom("Retro Gaming", size: 16))
                    
                    Picker("Appearance", selection: $selectedNum) {
                        ForEach(numOfMinesList, id: \.self) {
                            Text("\($0)")
                        }
                    }
                    .pickerStyle(.automatic)
                    .accentColor(.black)
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
        }
        // to prevent the preview crash
        .environmentObject(GameViewModel())
    }
}
