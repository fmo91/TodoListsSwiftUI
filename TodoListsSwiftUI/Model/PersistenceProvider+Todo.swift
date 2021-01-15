//
//  PersistenceProvider+Todo.swift
//  TodoListsSwiftUI
//
//  Created by Fernando Martín Ortiz on 15/01/2021.
//

import CoreData

extension PersistenceProvider {
    func todosRequest(for list: TodoList) -> NSFetchRequest<Todo> {
        let request: NSFetchRequest<Todo> = Todo.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(Todo.list), list)
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Todo.completed, ascending: true),
            NSSortDescriptor(keyPath: \Todo.creationDate, ascending: false)
        ]
        return request
    }
    
    @discardableResult
    func createTodo(with title: String, in list: TodoList) -> Todo {
        let todo = Todo(context: context)
        todo.title = title
        todo.creationDate = Date()
        list.addToTodos(todo)
        try? context.save()
        return todo
    }
    
    func toggle(_ todo: Todo) {
        todo.completed.toggle()
        try? context.save()
    }
    
    func delete(_ todos: [Todo]) {
        for todo in todos {
            context.delete(todo)
        }
        try? context.save()
    }
}
