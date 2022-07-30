//
//  FirebaseAuthService.swift
//  Pika Pika
//
//  Created by KoingDev on 29/7/22.
//

import Foundation
import FirebaseAuth

protocol FirebaseAuthServiceType {
    var isLoggedIn: Bool { get }
    func register(email: String, password: String) async -> Result<String, Error>
    func login(email: String, password: String) async -> Result<Void, Error>
    func logout()
}

final class FirebaseAuthService: FirebaseAuthServiceType {

    var isLoggedIn: Bool {
        Auth.auth().currentUser != nil
    }

    func login(email: String, password: String) async -> Result<Void, Error> {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            debugPrint("Login: \(result.user.uid)")
            return .success(())
        } catch {
            debugPrint("Error: \(error.localizedDescription)")
            return .failure(error)
        }
    }

    func register(email: String, password: String) async -> Result<String, Error> {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let uid = result.user.uid
            debugPrint("Register: \(uid)")
            return .success(uid)
        } catch {
            debugPrint("Error: \(error.localizedDescription)")
            return .failure(error)
        }
    }
    
    func logout() {
        try? Auth.auth().signOut()
    }
}
