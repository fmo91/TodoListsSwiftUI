//
//  PersistenceProvider.swift
//  TodoListsSwiftUI
//
//  Created by Fernando Martín Ortiz on 15/01/2021.
//

import Foundation
import CoreData

final class PersistenceProvider {
    private lazy var storeCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("TodoListsSwiftUI.sqlite")
        try! coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                            configurationName: nil,
                                            at: url,
                                            options: nil)
        return coordinator
    }()
    
    private lazy var model: NSManagedObjectModel = {
        let url = Bundle.main.url(forResource: "TodoListsSwiftUI", withExtension: "momd")!
        let model = NSManagedObjectModel(contentsOf: url)
        return model!
    }()
    
    private(set) lazy var context: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = storeCoordinator
        return context
    }()
    
    static let `default`: PersistenceProvider = PersistenceProvider()
    private init() {}
}

extension PersistenceProvider {
    var allListsRequest: NSFetchRequest<TodoList> {
        let request: NSFetchRequest<TodoList> = TodoList.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TodoList.creationDate, ascending: false)]
        return request
    }
    
    func createList(with title: String) {
        let list = TodoList(context: context)
        list.title = title
        list.creationDate = Date()
        try? context.save()
    }
    
    func delete(_ lists: [TodoList]) {
        for list in lists {
            PersistenceProvider.default.context.delete(list)
        }
        try? PersistenceProvider.default.context.save()
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
    
    func createTodo(with title: String, in list: TodoList) {
        let todo = Todo(context: context)
        todo.title = title
        todo.creationDate = Date()
        list.addToTodos(todo)
        try? context.save()
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
