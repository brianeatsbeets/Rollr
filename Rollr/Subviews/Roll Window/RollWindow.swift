//
//  RollWindow.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/19/23.
//

import SwiftUI

struct RollWindow: View {
    
    // Environment
    @Environment(\.modelContext) var modelContext
    
    // Binding
    @Binding var showingSettings: Bool
    @Binding var numberOfDice: Int
    @Binding var numberOfSides: Int
    @Binding var latestRoll: Roll?
    
    var body: some View {
        ZStack {
            
            // Background
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
            
            // Roll settings button
            VStack {
                Spacer()
                
                HStack(spacing: 0) {
                    Spacer()
                    
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gear")
                            .imageScale(.large)
                            .fontWeight(.semibold)
                    }
                    .padding([.bottom, .trailing], 15)
                }
            }
            
            // Roll settings values
            VStack {
                RollSettingsValues(numberOfDice: $numberOfDice, numberOfSides: $numberOfSides, scale: .regular)
                Spacer()
            }
            .padding(.top, 10)
            
            // Roll button
            VStack {
                Spacer()
                
                Button {
                    rollDice()
                } label: {
                    Text("Roll")
                        .padding(.horizontal, 30)
                        .padding(.vertical, 5)
                        .foregroundStyle(.white)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .fill(.tint)
                        )
                }
                .padding(.bottom)
            }
            
            // Roll info
            VStack(spacing: 0) {
                
                // Roll total
                Text(latestRoll?.total.description ?? "Awaiting roll...")
                    .font(.system(size: latestRoll != nil ? 125 : 30))
                    .padding(.vertical, latestRoll != nil ? -20 : 0)
                
                // Roll values
                Text(latestRoll?.values.description ?? "")
                    .font(.headline)
            }
        }
    }
    
    func rollDice() {
        var values = [Int]()
        for _ in 1...numberOfDice {
            values.append(Int.random(in: 1...numberOfSides))
        }
        latestRoll = Roll(values: values, rollSettings: RollSettings(numberOfDice: numberOfDice, numberOfSides: numberOfSides))
        modelContext.insert(latestRoll!)
    }
}

//#Preview {
//    RollWindow()
//}
