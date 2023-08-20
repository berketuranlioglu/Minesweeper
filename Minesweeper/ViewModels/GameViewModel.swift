//
//  GameViewModel.swift
//  Minesweeper
//
//  Created by Berke Turanlıoğlu on 25.06.2023.
//

import Foundation
import SwiftUI  // for Binding parameters passed to functions

let dummyCells = [
    CellModel(number: 1, isMine: false),
    CellModel(number: 2, isMine: false),
    CellModel(number: 3, isMine: true)
]

class GameViewModel: ObservableObject {
    
    var cells: [CellModel] = [] {
        didSet {
            if cells.last?.isMine == true {
                print("Cell with mine is: \(String(describing: cells.last?.number))")
            }
        }
    }
    @Published var mineField: [[CellModel]] = [[]]
    @Published var remainingFlags: Int = 0
    var revealedCells: Int = 0
    var numberOfMines: Int = 0
    
    init() {
        cells = []
        mineField = []
    }
    
    func createMineField(numOfMines: Int) {
        
        cells = []
        mineField = []
        
        let mineLocations: [Int] = generateMineLocations(numOfMines: numOfMines)
        
        for i in 0...287 {
            if mineLocations.contains(i) {
                cells.append(CellModel(number: i, isMine: true, neighborMines: -1))
            } else {
                cells.append(CellModel(number: i, isMine: false))
            }
        }
        
        prepareBoardAndNeighbors()
    }
    
    // initiating random mine locations
    func generateMineLocations(numOfMines: Int) -> [Int] {
        var mineList: [Int] = []
        while mineList.count < numOfMines {
            let mine = Int.random(in: 0...287)
            // preventing re-occurence of same mine location
            if !mineList.contains(mine) {
                mineList.append(mine)
            }
        }
        remainingFlags = numOfMines
        numberOfMines = numOfMines
        print(mineList)
        return mineList
    }
    
    // calculating each cell's (.) number of neighbors that has a mine
    // t t t
    // l . r
    // b b b
    func prepareBoardAndNeighbors() {
        
        let placeholderMatrix = [[Int]](repeating: [Int](repeating: 0, count: 12), count: 24)
        let cellsCopy = cells
        
        var iter = cellsCopy.makeIterator()
        mineField = placeholderMatrix.map { $0.compactMap { _ in iter.next() } }
        
        var counter = 0
        
        for row in 0..<mineField.count {
            for col in 0..<mineField[row].count {
                // if it is not a mine
                if !mineField[row][col].isMine {
                    // top row
                    if row - 1 >= 0 {
                        if col - 1 >= 0 {
                            if mineField[row-1][col-1].isMine { // top left
                                counter += 1
                            }
                        }
                        if mineField[row-1][col].isMine { // top middle
                            counter += 1
                        }
                        if col + 1 < mineField[row].count {
                            if mineField[row-1][col+1].isMine { // top right
                                counter += 1
                            }
                        }
                    }
                    if col - 1 >= 0 {
                        if mineField[row][col-1].isMine { // left
                            counter += 1
                        }
                    }
                    if col + 1 < mineField[row].count {
                        if mineField[row][col+1].isMine { // right
                            counter += 1
                        }
                    }
                    // bottom row
                    if row + 1 < mineField.count {
                        if col - 1 >= 0 {
                            if mineField[row+1][col-1].isMine { // bottom left
                                counter += 1
                            }
                        }
                        if mineField[row+1][col].isMine { // bottom middle
                            counter += 1
                        }
                        if col + 1 < mineField[row].count {
                            if mineField[row+1][col+1].isMine { // bottom right
                                counter += 1
                            }
                        }
                    }
                    mineField[row][col].neighborMines = counter
                    counter = 0
                }
            }
        }
    }
    
    // reveals all neighbor cells that are zero
    func revealNeighborCells(row: Int, col: Int) {
        // check if the cell is neither a bomb, flagged nor revealed
        if !(mineField[row][col].isMine || mineField[row][col].isFlagged || mineField[row][col].isRevealed) {
            // cell is okay to be revealed
            mineField[row][col].isRevealed = true
            revealedCells += 1
            // go for the neighbors if the current cell's value is zero
            if mineField[row][col].neighborMines == 0 {
                revealNeighborCells(row: max(0, row - 1), col: col)                                                     // upper cell
                revealNeighborCells(row: max(0, row - 1), col: max(0, col - 1))                                         // upper left
                revealNeighborCells(row: max(0, row - 1), col: min(mineField[0].count - 1, col + 1))                    // upper right
                revealNeighborCells(row: min(mineField.count - 1, row + 1), col: col)                                   // lower
                revealNeighborCells(row: min(mineField.count - 1, row + 1), col: max(0, col - 1))                       // lower left
                revealNeighborCells(row: min(mineField.count - 1, row + 1), col: min(mineField[0].count - 1, col + 1))  // lower right
                revealNeighborCells(row: row, col: max(0, col - 1))                                                     // left
                revealNeighborCells(row: row, col: min(mineField[0].count - 1, col + 1))                                // right
            }
        }
    }
    
    func revealTheCell(row: Int, col: Int, gameOver: () -> Void, userWins: () -> Void) {
        if !mineField[row][col].isFlagged {
            if mineField[row][col].isMine {
                mineField[row][col].isRevealed = true
                gameOver()
            } else {
                revealNeighborCells(row: row, col: col)
                userWins()
            }
        }
    }
    
    func checkIfPlayerWins() -> Bool {
        return 288 - revealedCells == numberOfMines
    }
    
    // flagging a cell
    func flagCell(row: Int, col: Int) {
        // number of flags has to be more than zero
        if remainingFlags > 0 {
            
            // put / remove the flag
            if !mineField[row][col].isRevealed {
                mineField[row][col].isFlagged.toggle()
            }
            
            if mineField[row][col].isFlagged {
                remainingFlags -= 1
            } else {
                remainingFlags += 1
            }
        }
        // or the player can only remove the flag
        else if mineField[row][col].isFlagged {
            mineField[row][col].isFlagged.toggle()
            remainingFlags += 1
        }
    }
}
