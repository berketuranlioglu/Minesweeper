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
            GeometryReader { geo in
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
                .navigationTitle("Minesweeper")
                .navigationBarTitleDisplayMode(.inline)
            }
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
        Rectangle()
            .foregroundColor(gameViewModel.mineField[row][col].isRevealed
                             ? (gameViewModel.mineField[row][col].isMine ? .red : .green) : .gray)
            .border(.black, width: 1)
            // to reveal the cell
            .onTapGesture {
                isOver = gameViewModel.revealCells(row: row, col: col)
            }
            // to flag the cell
            .onLongPressGesture {
                gameViewModel.flagCell(row: row, col: col)
            }
            .overlay(
                // flag is shown with "F"
                Text(gameViewModel.mineField[row][col].isFlagged
                     ? "F"
                     : (gameViewModel.mineField[row][col].isRevealed
                        ? "\(gameViewModel.mineField[row][col].neighborMines == 0 ? "" : "\(gameViewModel.mineField[row][col].neighborMines)")"
                        : ""))
            )
            .alert(isPresented: $isOver) {
                Alert(title: Text("Game Over!"),
                      dismissButton: .default(Text("Return home")) {
                    self.presentation.wrappedValue.dismiss()
                })
            }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
