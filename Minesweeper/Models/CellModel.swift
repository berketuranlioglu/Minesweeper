//
//  CellModel.swift
//  Minesweeper
//
//  Created by Berke Turanlıoğlu on 25.06.2023.
//

import Foundation

struct CellModel: Identifiable, Codable {
    let id: String
    let number: Int
    let isMine: Bool
    var neighborMines: Int
    var isRevealed: Bool
    var isFlagged: Bool
    
    // id is auto-created with this initializer
    init(id: String = UUID().uuidString, number: Int, isMine: Bool, neighborMines: Int = 0, isRevealed: Bool = false, isFlagged: Bool = false) {
        self.id = id
        self.number = number
        self.isMine = isMine
        self.neighborMines = neighborMines
        self.isRevealed = isRevealed
        self.isFlagged = isFlagged
    }
}
