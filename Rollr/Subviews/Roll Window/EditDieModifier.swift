//
//  EditDieModifier.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 11/7/23.
//

// MARK: - Imported libraries

import Combine
import SwiftUI

// MARK: - Main struct

// This struct provides a view that allows the user to update a given die's modifier
struct EditDieModifier: View {
    
    // MARK: - Properties
    
    // Environment
    
    @Environment(\.dismiss) var dismiss
    //@EnvironmentObject var currentRoll: LocalRoll
    
    // State
    
    @State private var newValue = ""
    @State private var polarity = "+"
    @FocusState private var isTextfieldFocused: Bool
    
    // Basic
    
    var dieIndex: Int
    var completion: (Int) -> Void
    
    // MARK: Initializers
    
    init(dieIndex: Int, completion: @escaping (Int) -> Void) {
        self.dieIndex = dieIndex
        self.completion = completion
    }
    
    // MARK: - Body view
    
    var body: some View {
        NavigationStack {
            
            // Main stack
            VStack(spacing: 0) {
                
                Text("Modifier value")
                    .font(.title2.weight(.medium))
                
                // Value stack
                HStack(spacing: 0) {
                    
                    // Value polarity
                    Text(polarity)
                        .font(Font(UIFont.systemFont(ofSize: 50, weight: .semibold)))
                        .padding(.leading, -5)
                        .padding(.top, -7)
                        .frame(width: 25)
                    
                    // Value textfield and underline
                    VStack(spacing: 0) {
                        TextField("", text: $newValue)
                            .font(Font(UIFont.systemFont(ofSize: 50, weight: .semibold)))
                            .fixedSize()
                            .multilineTextAlignment(.center)
                            .focused($isTextfieldFocused)
                            .tint(.clear)
                            .keyboardType(.numberPad)
                        
                            // Apply text limitations
                            .onReceive(Just(newValue)) { _ in enforceLimitations() }
                        
                            // Polarity button toolbar
                            .toolbar {
                                ToolbarItem(placement: .keyboard) {
                                    Button {
                                        if polarity == "+" {
                                            polarity = "-"
                                        } else {
                                            polarity = "+"
                                        }
                                    } label: {
                                        Image(systemName: "plus.slash.minus")
                                            .bold()
                                            .imageScale(.large)
                                    }
                                    .buttonStyle(BorderedButtonStyle())
                                }
                            }
                        
                        Rectangle()
                            .frame(width: 65, height: 4)
                            .padding(.top, -5)
                    }
                }
            }
            .padding(.top, -30)
            .navigationBarTitleDisplayMode(.inline)
            
            // Cancel/Save buttons
            .toolbar {
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        completion(Int(polarity + newValue)!)
                        dismiss()
                    }
                    .disabled(Int(newValue) == nil)
                }
            }
            .onAppear {
                isTextfieldFocused = true
            }
        }
    }
    
    // Apply formatting rules to text field
    func enforceLimitations() {
        
        // Prevent the value from beign longer than 2 digits
        if newValue.count > 2 {
            newValue = String(newValue.prefix(2))
        }
        
        // Prevent the first digit in the value from being 0
        if newValue.first == "0" {
            newValue = String(newValue.suffix(newValue.count - 1))
        }
    }
}

//#Preview {
//    EditDieModifier(dieIndex: 0, completion: { _ in })
//}
