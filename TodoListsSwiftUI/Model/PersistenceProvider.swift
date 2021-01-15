//
//  PersistenceProvider.swift
//  TodoListsSwiftUI
//
//  Created by Fernando Martín Ortiz on 15/01/2021.
//

import Foundation
import CoreData

final class PersistenceProvider {
    enum StoreType {
        case inMemory, persisted
    }
    
    static var managedObjectModel: NSManagedObjectModel = {
        let bundle = Bundle(for: PersistenceProvider.self)
        guard let url = bundle.url(forResource: "TodoListsSwiftUI", withExtension: "momd") else {
            fatalError("Failed to locate momd file for TodoListsSwiftUI")
        }
        guard let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to load momd file for TodoListsSwiftUI")
        }
        return model
    }()
    
    let persistentContainer: NSPersistentContainer
    var context: NSManagedObjectContext { persistentContainer.viewContext }
    
    static let `default`: PersistenceProvider = PersistenceProvider()
    init(storeType: StoreType = .persisted) {
        persistentContainer = NSPersistentContainer(name: "TodoListsSwiftUI", managedObjectModel: Self.managedObjectModel)
        
        if storeType == .inMemory {
            persistentContainer.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        persistentContainer.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed loading persistent stores with error: \(error.localizedDescription)")
            }
        }
    }
}

extension PersistenceProvider {
    var allListsRequest: NSFetchRequest<TodoList> {
        let request: NSFetchRequest<TodoList> = TodoList.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TodoList.creationDate, ascending: false)]
        return request
    }
    
    @discardableResult
    func createList(with title: String) -> TodoList {
        let list = TodoList(context: context)
        list.title = title
        list.creationDate = Date()
        try? context.save()
        return list
    }
    
    func delete(_ lists: [TodoList]) {
        for list in lists {
            context.delete(list)
        }
        try? context.save()
    }
}

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
