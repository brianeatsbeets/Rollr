//
//  MultiHexagon.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/19/23.
//

import SwiftUI

struct MultiHexagon: View {
    var size: CGFloat
    
    var body: some View {
        ZStack {
            Image(systemName: "hexagon.fill")
                .font(.system(size: size))
                .offset(x: 0, y: -size/3)
            Image(systemName: "hexagon.fill")
                .font(.system(size: size))
                .offset(x: -size/3, y: size/3)
            Image(systemName: "hexagon.fill")
                .font(.system(size: size))
                .offset(x: size/3, y: size/3)
        }
        .frame(width: size*2, height: size*2)
    }
}

#Preview {
    MultiHexagon(size: 100)
}
