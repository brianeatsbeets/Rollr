//
//  SidesHexagon.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/19/23.
//

import SwiftUI

struct SidesHexagon: View {
    
    let numberOfSides: Int
    
    var body: some View {
        Image(systemName: "hexagon.fill")
            .resizable()
            .scaledToFit()
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

enum RollSettingsValuesScale {
    case regular, small
}

#Preview {
    HStack {
        SidesHexagon(numberOfSides: 20)
        SidesHexagon(numberOfSides: 20)
        SidesHexagon(numberOfSides: 20)
        SidesHexagon(numberOfSides: 20)
    }
}
