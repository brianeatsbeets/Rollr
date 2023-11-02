//
//  ContentView.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/18/23.
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// This struct provides a view that serves as the base container for the app
struct ContentView: View {
    
    // MARK: - Properties
    
    // Environment
    
    @Environment(\.colorScheme) var theme
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.managedObjectContext) var moc
    
    // State
    
    // Using @State instead of @AppStorage because it maintains animations
    @State private var rollHistoryPosition: RollHistoryLandscapePosition
    
    // MARK: - Initializers
    
    init() {
        
        // Load initial roll history position
        if let position = RollHistoryLandscapePosition(rawValue: UserDefaults.standard.integer(forKey: "rollHistoryPosition")) {
            _rollHistoryPosition = State(initialValue: position)
        } else {
            _rollHistoryPosition = State(initialValue: .left)
        }
    }
    
    // MARK: - Body view
    
    var body: some View {
        NavigationStack {
                
            // Main stack
            AdaptiveStack(spacing: 0) {
                
                // Set roll window in right position
                if rollHistoryPosition == .left && verticalSizeClass == .compact {
                        
                    // Roll history list
                    RollHistoryList()
                        //.animation(.default, value: rollHistoryPosition)
                }
                 
                VStack {
                    
                    // Roll window
                    RollWindow()
                        .padding([.horizontal])
                    
                    // Dice options
                    DiceOptions()
                        .padding(.horizontal)
                        //.padding(.bottom, verticalSizeClass == .regular ? 0 : 20)
                }
                
                // Only display if in portrait mode
                if verticalSizeClass == .regular {
                    Divider()
                        .padding()
                }
                
                // Set roll window in left/top position
                if rollHistoryPosition == .right || verticalSizeClass == .regular {
                    
                    // Roll history list
                    RollHistoryList()
                        //.animation(.default, value: rollHistoryPosition)
                }
            }
            .navigationTitle("Rollr")
            .navigationBarTitleDisplayMode(.inline)
            .background(theme == .light ? Color(uiColor: .secondarySystemBackground) : Color(uiColor: UIColor.systemGroupedBackground))
            .toolbar {
                Button {
                    
                    withAnimation {
                        
                        // Toggle the roll history position
                        if rollHistoryPosition == .left {
                            rollHistoryPosition = .right
                        } else {
                            rollHistoryPosition = .left
                        }
                    }
                } label: {
                    Text("Swap sides")
                }
                .buttonStyle(BorderedProminentButtonStyle())
                .scaleEffect(0.8)
                
                // Hide when in portrait mode
                .conditionalHidden(verticalSizeClass == .regular)
            }
            
            // Update the roll history position in user defaults
            .onChange(of: rollHistoryPosition) { newValue in
                UserDefaults.standard.set(newValue.rawValue, forKey: "rollHistoryPosition")
            }
            
            // Prevents layout from squishing when entering a new preset name
            .ignoresSafeArea(.keyboard)
        }
    }
    
    // MARK: - Enums
    
    // This enum represents which side RollHistoryList resides on while in landscape mode
    enum RollHistoryLandscapePosition: Int {
        case left
        case right
    }
}

//#Preview {
//    ContentView()
//}
