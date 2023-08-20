//
//  MinesweeperApp.swift
//  Minesweeper
//
//  Created by Berke Turanlıoğlu on 15.08.2023.
//

import SwiftUI

@main
struct MinesweeperApp: App {
    
    @StateObject var gameViewModel = GameViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
            }
            .environmentObject(gameViewModel)
        }
    }
}
