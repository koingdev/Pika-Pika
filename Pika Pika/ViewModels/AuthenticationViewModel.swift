//
//  AuthenticationViewModel.swift
//  Pika Pika
//
//  Created by KoingDev on 29/7/22.
//

import Foundation

/// This viewModel is shared globally in a thread-safe manner
final class AuthenticationViewModel {

    static let shared = AuthenticationViewModel()
    
    @Atomic private(set) var loggedInUser: User?
    
    private let authService: FirebaseAuthServiceType
    private let userService: UserServiceType
    
    private init(
        authService: FirebaseAuthServiceType = FirebaseAuthService(),
        userService: UserServiceType = UserService()
    ) {
        self.authService = authService
        self.userService = userService
        
        fetchUserIfFirebaseLoggedIn()
    }
    
    func login(email: String, password: String) async -> Result<Void, Error> {
        guard isValid(email: email, password: password) else {
            return .failure(AppError.invalidInput)
        }

        let result = await authService.login(email: email, password: password)
        switch result {
        case .success(let uid):
            if let user = await userService.fetch(withUID: uid) {
                Self.shared.loggedInUser = user
            }
            return .success(())

        case .failure(let error):
            return .failure(error)
        }
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
            // TODO: update loggedIn user
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func logout() {
        authService.logout()
        Self.shared.loggedInUser = nil
    }
    
    func isLoggedIn() -> Bool {
        FirebaseAuthService.isLoggedIn
    }
    
    func isValid(email: String, password: String) -> Bool {
        let emailPattern = #"^\S+@\S+\.\S+$"#
        guard email.range(of: emailPattern, options: .regularExpression) != nil,
              password.count >= 6 else {
            return false
        }
        return true
    }
    
    
    private func fetchUserIfFirebaseLoggedIn() {
        if let uid = FirebaseAuthService.currentUser?.uid {
            Task {
                if let user = await userService.fetch(withUID: uid) {
                    Self.shared.loggedInUser = user
                }
            }
        }
    }
}
