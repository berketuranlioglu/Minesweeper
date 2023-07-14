//
//  GameView.swift
//  Minesweeper
//
//  Created by Berke Turanlıoğlu on 25.06.2023.
//

import SwiftUI

struct GameView: View {
    
    @StateObject var gameViewModel = GameViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(spacing: 0) {
                    ForEach(0 ..< gameViewModel.mineField.count, id:\.self) { row in
                        HStack(spacing: 0) {
                            ForEach(0 ..< gameViewModel.mineField[row].count, id:\.self) { col in
                                Cell(gameViewModel: gameViewModel, row: row, col: col)
                            }
                        }
                        .frame(width: .infinity)
                    }
                }
            }
            .navigationTitle(Text("Minesweeper"))
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            gameViewModel.createMineField()
        }
    }
}

// View for each cell
struct Cell: View {
    
    @Environment(\.presentationMode) var presentation
    @State var isOver: Bool = false
    
    @StateObject var gameViewModel: GameViewModel
    let row: Int
    let col: Int
    
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
                } else if gameViewModel.mineField[row][col].isFlagged {
                    ImageView(image: "flag")
                } else {
                    ImageView(image: "number_\(gameViewModel.mineField[row][col].neighborMines)")
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
        GameView()
    }
}
