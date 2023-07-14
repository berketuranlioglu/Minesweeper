//
//  GameView.swift
//  Minesweeper
//
//  Created by Berke Turanlıoğlu on 25.06.2023.
//

import SwiftUI

struct GameView: View {
    
    @Environment(\.presentationMode) var presentation
    
    @StateObject var gameViewModel = GameViewModel()
    let numOfMines: Int
    @State var remainingFlags: Int
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(spacing: 0) {
                    ForEach(0 ..< gameViewModel.mineField.count, id:\.self) { row in
                        HStack(spacing: 0) {
                            ForEach(0 ..< gameViewModel.mineField[row].count, id:\.self) { col in
                                Cell(gameViewModel: gameViewModel, row: row, col: col, remainingFlags: $remainingFlags)
                            }
                        }
                        .frame(width: .infinity)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        self.presentation.wrappedValue.dismiss()
                    } label: {
                        Text("Home")
                            .font(.custom("Retro Gaming", size: 14))
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Text("Flags: \(remainingFlags)")
                        .fontWeight(.bold)
                        .font(.custom("Retro Gaming", size: 14))
                }
            }
        }
        .onAppear {
            gameViewModel.createMineField(numOfMines: numOfMines)
        }
    }
}

// View for each cell
struct Cell: View {
    
    @Environment(\.presentationMode) var presentation
    @State var isOver: Bool = false
    @State var isSuccess: Bool = false
    
    @StateObject var gameViewModel: GameViewModel
    let row: Int
    let col: Int
    @Binding var remainingFlags: Int
    
    var body: some View {
        ZStack {
            Image(gameViewModel.mineField[row][col].isRevealed ? "tile_revealed" : "tile_hidden")
                .resizable()
            // to reveal the cell
                .onTapGesture {
                    if !gameViewModel.mineField[row][col].isFlagged {
                        if gameViewModel.mineField[row][col].isMine {
                            gameViewModel.mineField[row][col].isRevealed = true
                            isOver = true
                        } else {
                            gameViewModel.revealCells(row: row, col: col)
                        }
                    }
                }
            // to flag the cell
                .onLongPressGesture {
                    gameViewModel.flagCell(row: row, col: col)
                    if gameViewModel.mineField[row][col].isFlagged {
                        remainingFlags -= 1
                        if remainingFlags == 0 {
                            isSuccess = true
                        }
                    } else {
                        remainingFlags += 1
                    }
                }
                .alert(isPresented: $isOver) {
                    Alert(title: Text("Game Over!"),
                          dismissButton: .default(Text("Return home")) {
                        self.presentation.wrappedValue.dismiss()
                    })
                }
            
            if gameViewModel.mineField[row][col].isRevealed {
                if gameViewModel.mineField[row][col].isMine {
                    ImageView(image: "mine")
                } else {
                    ImageView(image: "number_\(gameViewModel.mineField[row][col].neighborMines)")
                }
            } else if gameViewModel.mineField[row][col].isFlagged {
                ImageView(image: "flag")
                    .alert(isPresented: $isSuccess) {
                        Alert(title: Text("You've done it!"),
                              dismissButton: .default(Text("Return home")) {
                            self.presentation.wrappedValue.dismiss()
                        })
                    }
            }
        }
    }
}

struct ImageView: View {
    
    let image: String
    
    var body: some View {
        Image(image)
            .resizable()
            .scaledToFit()
            .aspectRatio(0.8, contentMode: .fit)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(numOfMines: 48, remainingFlags: 48)
    }
}
