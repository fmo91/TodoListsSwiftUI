//
//  TodoListView.swift
//  TodoListsSwiftUI
//
//  Created by Fernando Martín Ortiz on 15/01/2021.
//

import SwiftUI

struct TodoListView: View {
    let todos: FetchedResults<Todo>
    let onSelect: (Todo) -> Void
    let onDelete: ([Todo]) -> Void
    
    var body: some View {
        List {
            ForEach(todos) { todo in
                VStack {
                    Text((todo.completed ? "[COMPLETED] " : "") + (todo.title ?? ""))
                        .foregroundColor(todo.completed ? Color.gray : Color.black)
                    }
                    .padding()
                    .onTapGesture {
                        onSelect(todo)
                    }
            }
            .onDelete { indexSet in onDelete(todos.get(indexSet)) }
        }
    }
}
