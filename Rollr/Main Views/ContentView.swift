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
    @EnvironmentObject var currentSession: Session
    @EnvironmentObject var animationStateManager: AnimationStateManager
    
    // State
    
    // Using @State instead of @AppStorage because it maintains animations
    @State private var rollHistoryPosition: RollHistoryLandscapePosition
    
    // Basic
    
    // Detect if the device screen has a notch (i.e. is a "frameless" version of the phone)
    var hasNotch: Bool {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else { return false }
        
        return window.safeAreaInsets.bottom > 0
    }
    
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
            
            // Used to apply modifier that prevents keyboard from shifting view up
            GeometryReader { _ in
                
                // Main stack
                AdaptiveStack(spacing: 0) {
                    
                    // Set roll window in right position
                    if rollHistoryPosition == .left && verticalSizeClass == .compact {
                        
                        // Roll history list
                        ListContainer()
                    }
                    
                    VStack {
                        
                        // Roll window
                        RollWindow()
                            .padding([.horizontal])
                        
                        // Dice options
                        DiceOptions()
                            .padding(.horizontal)
                            .padding(.bottom, !hasNotch && verticalSizeClass == .compact ? 10 : 0)
                    }
                    
                    // Only display if in portrait mode
                    if verticalSizeClass == .regular {
                        Divider()
                            .padding()
                    }
                    
                    // Set roll window in left/top position
                    if rollHistoryPosition == .right || verticalSizeClass == .regular {
                        
                        // Roll history list
                        ListContainer()
                    }
                }
                .navigationTitle(currentSession.wrappedName)
                .navigationBarTitleDisplayMode(.inline)
                .background(theme == .light ? Color(uiColor: .secondarySystemBackground) : Color(uiColor: UIColor.systemGroupedBackground))
                .toolbar {
                    
                    // Sawp sides button
                    if verticalSizeClass != .regular {
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
                    }
                    
                    // Session button
                    Menu("Sessions") {
                        Button("New") {
                            print("New session")
                        }
                        Button("Load") {
                            print("Load session")
                        }
                    }
                }
                
                // Update the roll history position in user defaults
                .onChange(of: rollHistoryPosition) { newValue in
                    UserDefaults.standard.set(newValue.rawValue, forKey: "rollHistoryPosition")
                }
            }
            
            // Prevents layout from squishing when entering a new preset name
            .ignoresSafeArea(.keyboard)
        }
    }
    
    // MARK: - Enums
    
    // This enum represents which side ListContainer resides on while in landscape mode
    enum RollHistoryLandscapePosition: Int {
        case left
        case right
    }
}

//#Preview {
//    ContentView()
//}
