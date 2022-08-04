//
//  MockFirebaseAuthService.swift
//  Pika PikaTests
//
//  Created by KoingDev on 4/8/22.
//

import Foundation
import FirebaseAuth

@testable import Pika_Pika

class MockFirebaseAuthService: FirebaseAuthServiceType {

    var mockResult: Result<String, Error> = .failure(AppError.userNotFound)
    
    static var isLoggedIn: Bool = true
    static var currentUser: FirebaseAuth.User? = nil
    
    func login(email: String, password: String) async -> Result<String, Error> {
        return mockResult
    }
    
    func register(email: String, password: String) async -> Result<String, Error> {
        return mockResult
    }
    
    func logout() { }
}
