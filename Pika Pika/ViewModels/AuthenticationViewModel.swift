//
//  AuthenticationViewModel.swift
//  Pika Pika
//
//  Created by KoingDev on 29/7/22.
//

import Foundation

final class AuthenticationViewModel {

    private let authManager: FirebaseAuthProtocol
    
    init(authManager: FirebaseAuthProtocol = FirebaseAuthManager()) {
        self.authManager = authManager
    }
    
    func login(email: String, password: String) async -> Result<Void, Error> {
        guard isValid(email: email, password: password) else {
            return .failure(AuthError.invalidInput)
        }
        return await authManager.login(email: email, password: password)
    }
    
    func register(email: String, password: String) async -> Result<Void, Error> {
        guard isValid(email: email, password: password) else {
            return .failure(AuthError.invalidInput)
        }
        return await authManager.register(email: email, password: password)
    }
    
    func isValid(email: String, password: String) -> Bool {
        let emailPattern = #"^\S+@\S+\.\S+$"#
        guard email.range(of: emailPattern, options: .regularExpression) != nil,
              password.count >= 6 else {
            return false
        }
        return true
    }
}
