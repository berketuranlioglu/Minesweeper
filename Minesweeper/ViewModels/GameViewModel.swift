//
//  GameViewModel.swift
//  Minesweeper
//
//  Created by Berke Turanlıoğlu on 25.06.2023.
//

import Foundation

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
    
    init() {
        cells = []
        mineField = []
    }
    
    func createMineField() {
        
        cells = []
        mineField = []
        
        let mineLocations: [Int] = generateMineLocations(numOfMines: 20)
        
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
    func revealCells(row: Int, col: Int) {
        // check if the cell is neither a bomb, flagged nor revealed
        if !(mineField[row][col].isMine || mineField[row][col].isFlagged || mineField[row][col].isRevealed) {
            // cell is okay to be revealed
            mineField[row][col].isRevealed = true
            // go for the neighbors if the current cell's value is zero
            if mineField[row][col].neighborMines == 0 {
                revealCells(row: max(0, row - 1), col: col)                         // upper cell
                revealCells(row: min(mineField.count - 1, row + 1), col: col)       // lower cell
                revealCells(row: row, col: max(0, col - 1))                         // left cell
                revealCells(row: row, col: min(mineField[0].count - 1, col + 1))    // right cell
            }
        }
    }
    
    // flagging the cell
    func flagCell(row: Int, col: Int) {
        if !mineField[row][col].isRevealed {
            mineField[row][col].isFlagged.toggle()
        }
    }
}
