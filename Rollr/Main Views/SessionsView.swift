//
//  SessionsView.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 2/10/24.
//

import SwiftUI

struct SessionsView: View {
    
    // MARK: - Properties
    
    // Environment
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc
    //@EnvironmentObject var currentRoll: LocalRoll
    //@EnvironmentObject var currentSession: Session
    @EnvironmentObject var dataController: DataController
    
    // Fetch request
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.dateCreated, order: .reverse)], animation: .default) var sessions: FetchedResults<Session>
    
    // State
    
    //@State var completion: (_ session: Session) -> Void
    
    var body: some View {
        NavigationView {
            List {
                
                ForEach(sessions) { session in
                    
                    Button {
                        //completion(session)
                        dataController.currentSession = session
                        print("Current session roll count: \(dataController.currentSession.wrappedRolls.count)")
                        dismiss()
                    } label: {
                        VStack(alignment: .leading) {
                            Text(session.wrappedName)
                                .font(.title3)
                            Text("Created: \(session.wrappedDateCreated.formatted())")
                                .font(.caption)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .navigationTitle("Load Session")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                // Cancel button
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
            }
            
            // Re-add group-styled list top padding
            .onDisappear {
                UICollectionView.appearance().contentInset.top = -35
            }
        }
    }
}
