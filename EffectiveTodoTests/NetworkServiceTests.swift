//
//  NetworkServiceTests.swift
//  EffectiveTodoTests
//
//  Created by Максим Шишлов on 21.11.2024.
//

import XCTest

@testable import EffectiveTodo
final class NetworkServiceTests: XCTestCase {
    
    var networkService: NetworkService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        networkService = NetworkService.shared
    }
    
    override func tearDownWithError() throws {
        networkService = nil
        try super.tearDownWithError()
    }
    
    func testFetchTodosSuccess() throws {
        let expectation = self.expectation(description: "Fetch todos success")
        
        networkService.fetchTodos { result in
            switch result {
            case .success(let todos):
                XCTAssertFalse(todos.isEmpty, "Todos should not be empty")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Unexpected failure: \(error)")
            }
        }
        
        waitForExpectations(timeout: 5.0)
    }
    
    func testFetchTodosFailure() throws {
        let invalidURLService = NetworkService.shared
        invalidURLService.fetchTodos { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertNotNil(error, "Error should be returned")
            }
        }
    }
}
