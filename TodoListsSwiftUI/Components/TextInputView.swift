//
//  TextInputView.swift
//  TodoListsSwiftUI
//
//  Created by Fernando Martín Ortiz on 15/01/2021.
//

import SwiftUI

struct TextInputView: View {
    @State private var text = ""
    
    let title: String
    let actionTitle: String
    let onCreate: (String) -> Void
    
    var body: some View {
        HStack {
            TextField(title, text: $text)
            Button(actionTitle, action: {
                if text.isEmpty { return }
                
                onCreate(text)
                text = ""
            })
        }.padding()
    }
}
