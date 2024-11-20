//
//  TodoDetailScreen.swift
//  EffectiveTodo
//
//  Created by Максим Шишлов on 15.11.2024.
//

import SwiftUI

struct TodoDetailScreen: View {
    
    let todo: TodoItem?
    @EnvironmentObject private var todoViewModel: TodoViewModel
    
    /// View properties
    @State private var todoLabel: String = ""
    @State private var todoDetail: String = ""
    @State private var todoDate: Date = .now
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            /// Todo title
            TextField(todo?.todo ?? "Что нужно сделать?", text: $todoLabel)
                .font(.title.bold())
                .autocorrectionDisabled()
            
            /// Todo date picker
            Text(format(date: todo?.dateAdded ?? todoDate, format: "d/MM/YY"))
                .font(.caption)
                .foregroundStyle(.gray)
                .padding(.bottom, 8)
                .overlay {
                    DatePicker(
                        "",
                        selection: $todoDate,
                        displayedComponents: [.date]
                    )
                    .blendMode(.destinationOver)
                    .onChange(of: todoDate) { oldValue, newValue in
                        todoDate = newValue
                    }
                }
            
            /// Todo details
            TextField(todo?.detail ?? "У задачи есть описание?", text: $todoDetail, axis: .vertical)
                .autocorrectionDisabled()
        }
        .navigationBarTitleDisplayMode(.inline)
        .padding()
        .vSpacing(.top)
        .hSpacing(.leading)
        .onTapGesture {
            hideKeyboard()
        }
        .onDisappear {

            guard !todoLabel.isEmpty, !todoDetail.isEmpty else { return }
            
            if let todo {
                todoViewModel.editTodo(TodoItem(
                    id: todo.id,
                    todo: todoLabel,
                    detail: todoDetail,
                    dateAdded: todoDate,
                    completed: todo.completed
                ))
            } else {
                todoViewModel.addTodo(todoLabel, todoDetail, todoDate)
            }
        }
        .onAppear {
            if let todo {
                todoLabel = todo.todo
                todoDetail = todo.detail
                todoDate = todo.dateAdded
            }
        }
    }
}

#Preview {
    NavigationStack {
        TodoDetailScreen(todo: TodoItem.mockData[0])
            .environmentObject(TodoViewModel())
    }
}
