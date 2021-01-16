//
//  TodoListsListView.swift
//  TodoListsSwiftUI
//
//  Created by Fernando Martín Ortiz on 15/01/2021.
//

import SwiftUI

struct TodoListsListView: View {
    @FetchRequest(fetchRequest: PersistenceProvider.default.allListsRequest) var allLists: FetchedResults<TodoList>
    
    var body: some View {
        VStack {
            List {
                ForEach(allLists) { list in
                    NavigationLink(destination: TodoListDetailView(list: list)) {
                        Text(list.title ?? "")
                            .padding()
                    }
                }
                .onDelete(perform: { indexSet in
                    PersistenceProvider.default.delete(allLists.get(indexSet))
                })
            }
            
            TextInputView(
                title: "Add a new list",
                actionTitle: "Add",
                onCreate: { listText in
                    PersistenceProvider.default.createList(with: listText)
                }
            )
        }
        .navigationTitle("Lists")
    }
}
