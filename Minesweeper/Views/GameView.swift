//
//  GameView.swift
//  Minesweeper
//
//  Created by Berke Turanlıoğlu on 25.06.2023.
//

import SwiftUI

struct GameView: View {
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack {
                    VStack(spacing: 0) {
                        ForEach(1...24, id: \.self) { column in
                            HStack(spacing: 0) {
                                ForEach(1...12, id: \.self) { row in
                                    Cell()
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
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}

// View for each cell
struct Cell: View {
    
    @State var isPressed: Bool = false
    
    var body: some View {
        Rectangle()
            .foregroundColor(isPressed ? .green : .gray)
            .border(.black, width: 1)
            .onTapGesture {
                isPressed = true
            }
    }
}
