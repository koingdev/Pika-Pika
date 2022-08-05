//
//  AuthenticationViewModelTest.swift
//  Pika PikaTests
//
//  Created by KoingDev on 4/8/22.
//

import XCTest

@testable import Pika_Pika

class AuthenticationViewModelTest: XCTestCase {
    
    var viewModel: AuthenticationViewModel!
    
    // Dependencies
    var mockAuthService = MockFirebaseAuthService()
    var mockUserService = MockUserService()

    override func setUpWithError() throws {
        mockAuthService = MockFirebaseAuthService()
        mockUserService = MockUserService()
        viewModel = AuthenticationViewModel(authService: mockAuthService, userService: mockUserService)
    }
    
    func testLoginWithInvalidCredential() async {
        // Given
        let invalidEmail = "invalid_email"
        let invalidPassword = "123"
        
        // When
        let result = await viewModel.login(email: invalidEmail, password: invalidPassword)
        
        // Then
        switch result {
        case .success:
            XCTFail("Expected to get failure.")
        case .failure(let error):
            XCTAssertTrue(error as? AppError == AppError.invalidInput)
        }
    }
    
    func testLoginWithValidCredential() async {
        // Given
        let email = "koing@gmail.com"
        let password = "123456"
        let uid = "test_uuid"
        let mockResult = User(id: uid, email: "email", fullname: "fullname")
        mockAuthService.mockResult = .success(uid)
        mockUserService.mockFetchResult = mockResult
        
        // When
        let result = await viewModel.login(email: email, password: password)
        
        // Then
        switch result {
        case .success:
            XCTAssertTrue(viewModel.loggedInUser?.id == mockResult.id)
        case .failure:
            XCTFail("Expected to get success.")
        }
    }
    
    func testLogout() {
        viewModel.logout()
        XCTAssertTrue(viewModel.loggedInUser == nil)
    }
    
    func testRegisterWithInvalidCredential() async {
        // Given
        let invalidEmail = "invalid_email"
        let invalidPassword = "123"
        let invalidFullname = ""
        
        // When
        let result = await viewModel.register(email: invalidEmail, password: invalidPassword, fullname: invalidFullname)
        
        // Then
        switch result {
        case .success:
            XCTFail("Expected to get failure.")
        case .failure(let error):
            XCTAssertTrue(error as? AppError == AppError.invalidInput)
        }
    }
    
    func testRegisterWithValidCredential() async {
        // Given
        let email = "koing@gmail.com"
        let password = "123456"
        let fullname = "fullname"
        let uid = "test_uuid"
        mockAuthService.mockResult = .success(uid)
        mockUserService.mockSaveResult = .success(())
        
        // When
        let result = await viewModel.register(email: email, password: password, fullname: fullname)
        
        // Then
        switch result {
        case .success:
            XCTAssertTrue(viewModel.loggedInUser?.id == uid)
        case .failure:
            XCTFail("Expected to get success.")
        }
    }
    
    
    func testIsValidWithValidCredential() {
        // Given
        let invalidEmail = "abc@abc"
        let validPassword = "123"
        
        // When
        let result = viewModel.isValid(email: invalidEmail, password: validPassword)
        
        // Then
        XCTAssertTrue(result == false)
    }
    
    func testIsValidWithInvalidCredential() {
        // Given
        let invalidEmail = "abc@abc"
        let validPassword = "123456"
        
        // When
        let result = viewModel.isValid(email: invalidEmail, password: validPassword)
        
        // Then
        XCTAssertTrue(result == false)
    }

}
