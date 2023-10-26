//
//  NumberOfSidesHexagon.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/19/23.
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// This struct provides a view that displays the number of sides of a given die
struct NumberOfSidesHexagon: View {
    
    // MARK: - Properties
    
    // Environment
    
    @Environment(\.colorScheme) var theme
    
    // Basic
    
    let numberOfSides: Int
    let type: SidesHexagonType
    let rollValue: Int
    
    var imageForegroundColor: Color {
        switch type {
        case .rollWindow:
            return theme == .light ? .black : Color(white: 0.3)
        case .button:
            return .accentColor
        case .rollHistoryRow:
            
            // Set the color based on the roll value
            switch rollValue {
            case 1:
                return .red
            case numberOfSides:
                return .green
            default:
                return theme == .light ? .black : Color(white: 0.3)
            }
        }
    }
    var textForegroundColor: Color {
        switch type {
        case .rollWindow:
            return theme == .light ? .white : .black
        case .button:
            return .white
        case .rollHistoryRow:
            
            // Set the color based on the roll value
            switch rollValue {
            case 1, numberOfSides:
                return .white
            default:
                return .black
            }
        }
    }
    
    // MARK: - Initializers
    
    init(numberOfSides: Int, type: SidesHexagonType, rollValue: Int = 0) {
        self.numberOfSides = numberOfSides
        self.type = type
        self.rollValue = rollValue
    }
    
    // MARK: - Body view
    
    var body: some View {
        
        // Hexagon image
        Image(systemName: "hexagon.fill")
            .resizable()
            .scaledToFit()
            .foregroundStyle(imageForegroundColor)
            .overlay(
                GeometryReader { geo in
                    
                    // Number of sides
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

// MARK: - Enums

// This enum provides options for the context in which the view is displayed
enum SidesHexagonType {
    case rollWindow, button, rollHistoryRow
}

#Preview {
    HStack {
        NumberOfSidesHexagon(numberOfSides: 20, type: .rollWindow)
        NumberOfSidesHexagon(numberOfSides: 20, type: .rollWindow)
        NumberOfSidesHexagon(numberOfSides: 20, type: .rollWindow)
        NumberOfSidesHexagon(numberOfSides: 20, type: .rollWindow)
    }
}
