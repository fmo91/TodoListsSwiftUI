//
//  TodoListsSwiftUITests.swift
//  TodoListsSwiftUITests
//
//  Created by Fernando Martín Ortiz on 15/01/2021.
//

import XCTest
@testable import TodoListsSwiftUI

class TodoListsSwiftUITests: XCTestCase {
    var provider: PersistenceProvider!

    override func setUpWithError() throws {
        provider = PersistenceProvider(storeType: .inMemory)
    }

    func test_saveTodoList() throws {
        provider.createList(with: "Lista 1")
        let lists = try provider.context.fetch(provider.allListsRequest)
        XCTAssertEqual(lists.count, 1)
        XCTAssertEqual(lists[0].title, "Lista 1")
    }
    
    func test_deleteTodoList() throws {
        let list1 = provider.createList(with: "Lista 1")
        provider.createList(with: "Lista 2")
        let list3 = provider.createList(with: "Lista 3")
        provider.createList(with: "Lista 4")
        provider.delete([list1, list3])
        let lists = try provider.context.fetch(provider.allListsRequest)
        XCTAssertEqual(lists.count, 2)
    }
    
    func test_saveTodo() throws {
        let list = provider.createList(with: "Lista 1")
        provider.createTodo(with: "Todo 1", in: list)
        provider.createTodo(with: "Todo 2", in: list)
        
        let todos = try provider.context.fetch(provider.todosRequest(for: list))
        XCTAssertEqual(todos.count, 2)
        XCTAssertEqual(
            todos.map { $0.title },
            ["Todo 2", "Todo 1"]
        )
    }
    
    func test_deleteTodo() throws {
        let list = provider.createList(with: "Lista 1")
        provider.createTodo(with: "Todo 1", in: list)
        let todo2 = provider.createTodo(with: "Todo 2", in: list)
        provider.createTodo(with: "Todo 3", in: list)
        
        provider.delete([todo2])
        
        let todos = try provider.context.fetch(provider.todosRequest(for: list))
        XCTAssertEqual(todos.count, 2)
        XCTAssertEqual(
            todos.map { $0.title },
            ["Todo 3", "Todo 1"]
        )
    }
}
