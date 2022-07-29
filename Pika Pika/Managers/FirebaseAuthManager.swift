//
//  AuthenticationManager.swift
//  Pika Pika
//
//  Created by KoingDev on 29/7/22.
//

import Foundation
import FirebaseAuth

protocol FirebaseAuthProtocol {
    func register(email: String, password: String) async -> Result<Void, Error>
    func login(email: String, password: String) async -> Result<Void, Error>
}

final class FirebaseAuthManager: FirebaseAuthProtocol {

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

    func register(email: String, password: String) async -> Result<Void, Error> {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            debugPrint("Register: \(result.user.uid)")
            return .success(())
        } catch {
            debugPrint("Error: \(error.localizedDescription)")
            return .failure(error)
        }
    }
}
