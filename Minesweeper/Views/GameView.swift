//
//  GameView.swift
//  Minesweeper
//
//  Created by Berke Turanlıoğlu on 25.06.2023.
//

import SwiftUI

struct GameView: View {
    
    @EnvironmentObject var gameViewModel: GameViewModel
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack {
                    VStack(spacing: 0) {
                        ForEach(0 ..< gameViewModel.cells.count / 12, id:\.self) { row in
                            HStack(spacing: 0) {
                                ForEach(0 ..< 12, id:\.self) { column in
                                    let currentIndex = row * 12 + column
                                    Cell(currentCell: gameViewModel.cells[currentIndex])
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
    
    @State var isPressed: Bool = false
    @State var isLongPressed: Bool = false
    @State var isOver: Bool = false
    let currentCell: CellModel
    
    var body: some View {
        Rectangle()
            .foregroundColor(isPressed ? (currentCell.isMine ? .red : .green) : .gray)
            .border(.black, width: 1)
            // to reveal the cell
            .onTapGesture {
                isPressed = true
                if currentCell.isMine {
                    isOver = true
                }
            }
            // to flag the cell
            .onLongPressGesture {
                isLongPressed.toggle()
            }
            .overlay(
                // flag is shown with "F"
                Text(isLongPressed ? "F" : "")
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
            .environmentObject(GameViewModel())
    }
}
