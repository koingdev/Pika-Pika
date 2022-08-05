//
//  AddNewPostViewModelTest.swift
//  Pika PikaTests
//
//  Created by KoingDev on 5/8/22.
//

import XCTest

@testable import Pika_Pika

class AddNewPostViewModelTest: XCTestCase {
    
    var viewModel: AddNewPostViewModel!
    
    override func setUpWithError() throws {
        viewModel = AddNewPostViewModel()
    }
    
    func testPrepareInvalidFeed() {
        // Given
        let authViewModel = AuthenticationViewModel()
        
        // When
        let result = viewModel.prepareFeed(description: " ", image: nil, authViewModel: authViewModel)
        
        // Then
        XCTAssertTrue(result == nil)
    }
    
    func testPrepareWithoutLoggedInUser() {
        // Given
        let authViewModel = AuthenticationViewModel()
        authViewModel.loggedInUser = nil
        
        // When
        let result = viewModel.prepareFeed(description: "description", image: nil, authViewModel: authViewModel)
        
        // Then
        XCTAssertTrue(result == nil)
    }
    
    func testPrepareValidFeed() {
        // Given
        let authViewModel = AuthenticationViewModel()
        let user = User(id: "user_id", email: "email", fullname: "fullname")
        authViewModel.loggedInUser = user
        
        // When
        let result = viewModel.prepareFeed(description: "description", image: nil, authViewModel: authViewModel)
        
        // Then
        XCTAssertTrue(result?.uid == user.id, "Expected the same uid.")
        XCTAssertTrue(result?.description == "description", "Expected the same description.")
        XCTAssertTrue(result?.fullname == user.fullname, "Expected the same fullname.")
    }

}
