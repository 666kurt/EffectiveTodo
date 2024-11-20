//
//  ContentView.swift
//  EffectiveTodo
//
//  Created by Максим Шишлов on 14.11.2024.
//

import SwiftUI

struct TodoScreen: View {
    
    @State var searchText: String = ""
    @StateObject private var todoViewModel = TodoViewModel()
    
    var body: some View {
        NavigationStack {
            if todoViewModel.todos.isEmpty {
                ProgressView()
            } else {
                ZStack(alignment: .bottom) {
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: 0) {
                            ForEach(todoViewModel.todos.filter({ $0.todo.contains(searchText) || searchText.isEmpty }), id: \.id) { todo in
                                TodoRowView(todo: todo, todoViewModel: todoViewModel)
                                    .contextMenu {
                                        ContextMenuContent(for: todo)
                                    } preview: {
                                        TodoRowView(todo: todo, todoViewModel: todoViewModel)
                                            .background(.todoGray)
                                    }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 50)
                    
                    TodoBottomView()
                }
                .navigationTitle("Задачи")
                .searchable(text: $searchText, prompt: "Search")
            }
        }
    }
    
    /// TodoBottomView
    @ViewBuilder
    func TodoBottomView() -> some View {
        Text("\(todoViewModel.todos.count) задач")
            .hSpacing()
            .padding(.vertical, 16)
            .background(.todoGray)
            .overlay(alignment: .trailing) {
                NavigationLink {
                    TodoDetailScreen(todo: nil)
                        .environmentObject(todoViewModel)
                } label: {
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(.horizontal)
                }
            }
    }
    
    /// ContextMenuContent
    @ViewBuilder
    func ContextMenuContent(for todo: TodoItem) -> some View {
        NavigationLink {
            TodoDetailScreen(todo: todo)
                .environmentObject(todoViewModel)
        } label: {
            Label("Редактировать", systemImage: "square.and.pencil")
        }
        
        Button {
            // Share todo
        } label: {
            Label("Поделиться", systemImage: "square.and.arrow.up")
        }
        
        Button(role: .destructive) {
            todoViewModel.deleteTodo(todo)
        } label: {
            Label("Удалить", systemImage: "trash")
        }
    }
}

#Preview {
    TodoScreen()
}
