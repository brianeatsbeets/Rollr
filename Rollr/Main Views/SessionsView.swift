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
                    } label: {
                        HStack {
                            Text(session.wrappedName)
                                .font(.title)
                            Text(session.wrappedDateCreated.description)
                                .font(.headline)
                        }
                    }
                }
            }
            .navigationTitle("Load Session")
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
