//
//  TodoListDetailView.swift
//  TodoListsSwiftUI
//
//  Created by Fernando Martín Ortiz on 15/01/2021.
//

import SwiftUI

struct TodoListDetailView: View {
    let list: TodoList
    var todos: FetchRequest<Todo>
    
    @State var todoText = ""
    
    init(list: TodoList) {
        self.list = list
        self.todos = FetchRequest<Todo>(fetchRequest: PersistenceProvider.default.todosRequest(for: list))
    }
    
    var body: some View {
        VStack {
            TodoListView(
                todos: todos.wrappedValue,
                onSelect: { todo in
                    PersistenceProvider.default.toggle(todo)
                },
                onDelete: { todos in
                    PersistenceProvider.default.delete(todos)
                }
            )
            TextInputView(
                title: "Add a new item",
                actionTitle: "Add",
                onCreate: { todoText in
                    PersistenceProvider.default.createTodo(with: todoText, in: list)
                }
            )
        }
        .navigationTitle(list.title ?? "")
    }
}
