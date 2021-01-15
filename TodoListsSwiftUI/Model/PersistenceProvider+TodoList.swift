//
//  PersistenceProvider+TodoList.swift
//  TodoListsSwiftUI
//
//  Created by Fernando Martín Ortiz on 15/01/2021.
//

import Foundation
import CoreData

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
