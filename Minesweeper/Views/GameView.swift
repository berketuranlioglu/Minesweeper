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
                                ForEach(0 ..< gameViewModel.mineField[row].count, id:\.self) { column in
                                    Cell(gameViewModel: gameViewModel, cell: gameViewModel.mineField[row][column])
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
    @State var cell: CellModel
    
    var body: some View {
        Rectangle()
            .foregroundColor(cell.isRevealed ? (cell.isMine ? .red : .green) : .gray)
            .border(.black, width: 1)
            // to reveal the cell
            .onTapGesture {
                
                if !cell.isFlagged {
                    cell.isRevealed = true
                    if cell.isMine {
                        isOver = true
                    }
                }
            }
            // to flag the cell
            .onLongPressGesture {
                if !cell.isRevealed {
                    cell.isFlagged.toggle()
                }
            }
            .overlay(
                // flag is shown with "F"
                Text(cell.isFlagged
                     ? "F"
                     : (cell.isRevealed
                        ? "\(cell.neighborMines == 0 ? "" : "\(cell.neighborMines)")"
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
