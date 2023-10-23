//
//  SidesHexagon.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/19/23.
//

import SwiftUI

struct SidesHexagon: View {
    
    let numberOfSides: Int
    let type: SidesHexagonType
    let rollValue: Int
    
    var foregroundColor: Color {
        switch type {
        case .rollWindow:
            return .black
        case .button:
            return .accentColor
        case .rollHistoryRow:
            
            switch rollValue {
            case 1:
                return .red
            case numberOfSides:
                return .green
            default:
                return .black
            }
        }
    }
    
    init(numberOfSides: Int, type: SidesHexagonType, rollValue: Int = 0) {
        self.numberOfSides = numberOfSides
        self.type = type
        self.rollValue = rollValue
    }
    
    var body: some View {
        Image(systemName: "hexagon.fill")
            .resizable()
            .scaledToFit()
            .foregroundStyle(foregroundColor)
            .overlay(
                GeometryReader { geo in
                    Text(numberOfSides, format: .number)
                        .font(.system(size: min(geo.size.height, geo.size.width) * 0.6))
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 3)
                        .position(x: geo.frame(in: .local).midX, y: geo.frame(in: .local).midY)
                }
            )
    }
}

enum SidesHexagonType {
    case rollWindow, button, rollHistoryRow
}

#Preview {
    HStack {
        SidesHexagon(numberOfSides: 20, type: .rollWindow)
        SidesHexagon(numberOfSides: 20, type: .rollWindow)
        SidesHexagon(numberOfSides: 20, type: .rollWindow)
        SidesHexagon(numberOfSides: 20, type: .rollWindow)
    }
}
