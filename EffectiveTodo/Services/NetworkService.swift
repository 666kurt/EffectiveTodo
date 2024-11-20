//
//  NetworkService.swift
//  EffectiveTodo
//
//  Created by Максим Шишлов on 15.11.2024.
//

import Foundation

final class NetworkService {
    
    static let shared = NetworkService()
    private init() {}
    
    private let urlString = "https://dummyjson.com/todos"
    
    func fetchTodos(completion: @escaping(Result<[Todo], TodoError>) -> Void) {
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, responce, error in
            
            if let error = error {
                completion(.failure(.unknownError(error: error)))
                return
            }
            
            guard let responce = responce as? HTTPURLResponse else {
                completion(.failure(.requestFailed(description: "Request failed")))
                return
            }
            
            guard responce.statusCode == 200 else {
                completion(.failure(.invalidStatusCode(statusCode: responce.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }

            do {
                let apiResponce = try JSONDecoder().decode(TodoAPIItem.self, from: data)
                completion(.success(apiResponce.todos))
            } catch _ {
                print("Failed to decode data")
                completion(.failure(.jsonParcingFailure))
            }
            
        }.resume()
        
    }
}
 
