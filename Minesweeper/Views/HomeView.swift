//
//  HomeView.swift
//  Minesweeper
//
//  Created by Berke Turanlıoğlu on 25.06.2023.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var gameViewModel: GameViewModel
    @State private var selectedNum = 36
    @State var instructionsPressed: Bool = false
    @State var rootActive: Bool = false
    
    var body: some View {
        VStack {
            
            Text("MINESWEEPER")
                .font(.custom("Retro Gaming", size: 36))
                .padding(.top, 40)
                
            Spacer()
            
            StartButton(selectedNum: $selectedNum, rootActive: $rootActive)
            
            Text("How many mines?")
                .font(.custom("Retro Gaming", size: 16))
                .padding(.all, 20)
            
            MinePicker(selectedNum: $selectedNum)
            
            Spacer()
                .frame(height: 16)
            
            Instructions()
            
            Spacer()
                .frame(height: 16)
            
            Link("Check GitHub for more projects!",
                 destination: URL(string: "https://github.com/berketuranlioglu")!)
                .font(.custom("Retro Gaming", size: 14))
        }
        .padding(.vertical, 20)
    }
}

struct StartButton: View {
    
    @Binding var selectedNum: Int
    @Binding var rootActive: Bool
    
    var body: some View {
        NavigationLink(destination: GameView(numOfMines: selectedNum, rootActive: $rootActive)
            .navigationBarBackButtonHidden(true), isActive: self.$rootActive, label: {
                Text("Start the game")
                    .font(.custom("Retro Gaming", size: 20))
            })
        .isDetailLink(false)
        .padding(.all, 20)
    }
}

struct MinePicker: View {
    
    @Binding var selectedNum: Int
    
    let options: [Int] = [24, 36, 48]
    
    var body: some View {
        HStack {
            ForEach(options, id: \.self) { option in
                Button(action: {
                    selectedNum = option
                }, label: {
                    Text("\(option)")
                        .font(.custom("Retro Gaming", size: 16))
                        .foregroundColor(selectedNum == option ? .blue : .black)
                })
                .padding(.horizontal)
            }
        }
    }
    
}

struct Instructions: View {
    var body: some View {
        Text("Put a flag (tap and hold) if you think that the cell contains a bomb underneath it. You win the game when you reveal all the cells except bombs.")
            .font(.custom("Retro Gaming", size: 14))
            .padding(.all, 44)
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
