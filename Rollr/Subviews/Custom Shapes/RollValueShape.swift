//
//  RollValueCircle.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/23/23.
//

import SwiftUI

struct RollValueShape: View {
    
    @Binding var die: Die
    
    var rollResult: String {
        die.result > 0 ? die.result.description : "-"
    }
    var backgroundSymbol: String {
        if die.result == 1 {
            return "square.fill"
        } else if die.result == die.numberOfSides.rawValue {
            return "burst.fill"
        }
        
        return "triangle.fill"
    }
    var scaleEffect: CGFloat {
        if die.result == die.numberOfSides.rawValue {
            return 1.25
        } else {
            return 0.85
        }
    }
    var fontWeight: Font.Weight {
        if die.result == 1 || die.result == die.numberOfSides.rawValue {
            return .semibold
        } else {
            return .regular
        }
    }
    var fontColor: Color {
        if die.result == 1 || die.result == die.numberOfSides.rawValue {
            return .white
        } else {
            return .primary
        }
    }
    var shapeColor: Color {
        if die.result == 1 {
            return .red
        } else if die.result == die.numberOfSides.rawValue {
            return .green
        }
        
        return .clear
    }
    
    var body: some View {
        
        Image(systemName: backgroundSymbol)
            .resizable()
            .scaledToFit()
            .scaleEffect(scaleEffect)
            .foregroundStyle(shapeColor)
            .overlay(
                Text(rollResult)
                    .font(.title3)
                    .fontWeight(fontWeight)
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                    .foregroundStyle(fontColor)
                    .padding(.horizontal, 5)
            )
    }
}

//#Preview {
//    HStack {
//        RollValueShape(showingResults: .constant(true), die: .constant(Die.maxRoll))
//    }
//    .frame(height: 40)
//}
