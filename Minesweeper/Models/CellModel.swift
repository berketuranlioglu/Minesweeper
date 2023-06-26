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
    
    // id is auto-created with this initializer
    init(id: String = UUID().uuidString, number: Int, isMine: Bool) {
        self.id = id
        self.number = number
        self.isMine = isMine
    }
}
