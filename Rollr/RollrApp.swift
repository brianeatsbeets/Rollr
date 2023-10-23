//
//  RollrApp.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/18/23.
//

import SwiftData
import SwiftUI

@main
struct RollrApp: App {
    
    var rolls = [Roll]()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .fontDesign(.rounded)
        }
        //.modelContainer(for: Roll.self)
    }
}
