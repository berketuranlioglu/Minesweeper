//
//  GameView.swift
//  Minesweeper
//
//  Created by Berke Turanlıoğlu on 15.08.2023.
//

import SwiftUI

struct GameView: View {
    
    @StateObject var gameViewModel = GameViewModel()
    let numOfMines: Int
    @Binding var rootActive: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(spacing: 0) {
                    ForEach(0 ..< gameViewModel.mineField.count, id:\.self) { row in
                        HStack(spacing: 0) {
                            ForEach(0 ..< gameViewModel.mineField[row].count, id:\.self) { col in
                                Cell(gameViewModel: gameViewModel, row: row, col: col, rootActive: $rootActive)
                            }
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        self.rootActive = false
                    } label: {
                        Text("Home")
                            .font(.custom("Retro Gaming", size: 14))
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Text("Flags: \(gameViewModel.remainingFlags)")
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
    
    @State var isOver: Bool = false
    @State var isSuccess: Bool = false
    
    @StateObject var gameViewModel: GameViewModel
    let row: Int
    let col: Int
    @Binding var rootActive: Bool
    
    var body: some View {
        ZStack {
            Image(gameViewModel.mineField[row][col].isRevealed ? "tile_revealed" : "tile_hidden")
                .resizable()
                // to reveal the cell
                .onTapGesture {
                    gameViewModel.revealTheCell(row: row, col: col, gameOver: {
                        isOver = true
                    }, userWins: {
                        isSuccess = gameViewModel.checkIfPlayerWins()
                    })
                }
                // to flag the cell
                .onLongPressGesture {
                    gameViewModel.flagCell(row: row, col: col)
                }
                // when the revealed cell is bomb
                .alert(isPresented: $isOver) {
                    Alert(title: Text("Game Over!"),
                          dismissButton: .default(Text("Return home")) {
                        self.rootActive = false
                    })
                }
            
            if gameViewModel.mineField[row][col].isRevealed {
                if gameViewModel.mineField[row][col].isMine {
                    ImageView(image: "mine")
                } else {
                    ImageView(image: "number_\(gameViewModel.mineField[row][col].neighborMines)")
                    // when the game is won
                    .alert(isPresented: $isSuccess) {
                        Alert(title: Text("You've done it!"),
                              dismissButton: .default(Text("Return home")) {
                            self.rootActive = false
                        })
                    }
                }
            } else if gameViewModel.mineField[row][col].isFlagged {
                ImageView(image: "flag")
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
        GameView(numOfMines: 48, rootActive: .constant(false))
    }
}
