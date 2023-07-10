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
    
    @Published var cells: [CellModel] = [] {
        didSet {
            if cells.last?.isMine == true {
                print("Cell with mine is: \(String(describing: cells.last?.number))")
            }
        }
    }
    
    init() {
        cells = []
    }
    
    func createMineField() {
        
        cells = []
        
        let mineLocations: [Int] = generateMineLocations(numOfMines: 20)
        
        for i in 0...287 {
            if mineLocations.contains(i) {
                cells.append(CellModel(number: i, isMine: true))
            } else {
                cells.append(CellModel(number: i, isMine: false))
            }
        }
    }
    
    func generateMineLocations(numOfMines: Int) -> [Int] {
        var mineList: [Int] = []
        while mineList.count < numOfMines {
            let mine = Int.random(in: 0...287)
            if !mineList.contains(mine) {
                mineList.append(mine)
            }
        }
        print(mineList)
        return mineList
    }
    
}
