//
//  Array+Convenience.swift
//  TodoListsSwiftUI
//
//  Created by Fernando Martín Ortiz on 15/01/2021.
//

import SwiftUI
import CoreData

extension FetchedResults {
    func get(_ indexSet: IndexSet) -> [Result] {
        var result = [Result]()
        for index in indexSet {
            result.append(self[index])
        }
        return result
    }
}
