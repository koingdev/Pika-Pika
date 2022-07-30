//
//  AuthenticationViewModel.swift
//  Pika Pika
//
//  Created by KoingDev on 29/7/22.
//

import Foundation

final class AuthenticationViewModel {

    private let authService: FirebaseAuthServiceType
    private let userService: UserServiceType
    
    init(
        authService: FirebaseAuthServiceType = FirebaseAuthService(),
        userService: UserServiceType = UserService()
    ) {
        self.authService = authService
        self.userService = userService
        
        authService.logout()
    }
    
    func login(email: String, password: String) async -> Result<Void, Error> {
        guard isValid(email: email, password: password) else {
            return .failure(AppError.invalidInput)
        }
        return await authService.login(email: email, password: password)
    }
    
    func register(email: String, password: String, fullname: String) async -> Result<Void, Error> {
        guard isValid(email: email, password: password), !fullname.isEmpty else {
            return .failure(AppError.invalidInput)
        }

        let result = await authService.register(email: email, password: password)
        switch result {
        case .success(let uid):
            return await userService.save(data: [
                "email": email,
                "fullname": fullname,
                "uid": uid
            ])
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func isLoggedIn() -> Bool {
        authService.isLoggedIn
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
