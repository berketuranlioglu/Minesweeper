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
    
    func revealCells() {
        
    }ß
}
