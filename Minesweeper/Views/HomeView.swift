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
    @State var instructionsPressed: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                
                Text("MINESWEEPER")
                    .font(.custom("Retro Gaming", size: 36))
                    .padding(.bottom, 160)
                
                NavigationLink(destination: GameView(numOfMines: selectedNum, remainingFlags: selectedNum)
                    .navigationBarBackButtonHidden(true), label: {
                    Text("Begin game")
                            .font(.custom("Retro Gaming", size: 20))
                })
                .padding(.all, 20)
                
                Text("How many mines?")
                    .font(.custom("Retro Gaming", size: 16))
                    .padding(.all, 20)
                
                MinePicker(selectedNum: $selectedNum)
                
                Spacer()
                
                Instructions()
                
                Spacer()
                
                Link("Check GitHub for more projects!", destination: URL(string: "https://github.com/berketuranlioglu")!)
                    .font(.custom("Retro Gaming", size: 12))
            }
        }
    }
}

struct MinePicker: View {
    
    @Binding var selectedNum: Int
    
    var body: some View {
        HStack {
            Button(action: {
                selectedNum = 36
            }, label: {
                Text("36")
                    .font(.custom("Retro Gaming", size: 16))
                    .foregroundColor(selectedNum == 36 ? .blue : .black)
            })
            Spacer()
            Button(action: {
                selectedNum = 48
            }, label: {
                Text("48")
                    .font(.custom("Retro Gaming", size: 16))
                    .foregroundColor(selectedNum == 48 ? .blue : .black)
            })
            Spacer()
            Button(action: {
                selectedNum = 60
            }, label: {
                Text("60")
                    .font(.custom("Retro Gaming", size: 16))
                    .foregroundColor(selectedNum == 60 ? .blue : .black)
            })
        }
        .frame(width: 160)
    }
    
}

struct Instructions: View {
    var body: some View {
        Text("Put a flag (tap and hold) if you think that the cell contains a bomb underneath it. You win the game when you place all the flags correctly.")
            .font(.custom("Retro Gaming", size: 12))
            .padding(.all, 40)
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
