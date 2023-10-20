//
//  RollSettingsView.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/19/23.
//

import SwiftUI

struct RollSettingsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var numberOfDice: Int
    @Binding var numberOfSides: Int
    
    let numberOfDiceOptions = [1, 2, 3, 4, 5]
    let numberOfSidesOptions = [4, 6, 8, 10, 12, 20, 100]
    
    var body: some View {
        NavigationStack {
            Form {
                VStack(alignment: .leading) {
                    Text("Number of dice")
                    Picker("Number of dice", selection: $numberOfDice) {
                        ForEach(numberOfDiceOptions, id: \.self) { number in
                            Text(number, format: .number)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(.segmented)
                }
                
                VStack(alignment: .leading) {
                    Text("Number of sides")
                    Picker("Number of sides", selection: $numberOfSides) {
                        ForEach(numberOfSidesOptions, id: \.self) { number in
                            Text(number, format: .number)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("Roll Settings")
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
            }
        }
        .presentationDetents([.height(250)])
    }
}

//#Preview {
//    RollSettingsView()
//}
