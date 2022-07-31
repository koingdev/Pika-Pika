//
//  FirebaseAuthService.swift
//  Pika Pika
//
//  Created by KoingDev on 29/7/22.
//

import Foundation
import FirebaseAuth

protocol FirebaseAuthServiceType {
    static var isLoggedIn: Bool { get }
    static var currentUser: FirebaseAuth.User? { get }
    func login(email: String, password: String) async -> Result<String, Error>
    func register(email: String, password: String) async -> Result<String, Error>
    func logout()
}

final class FirebaseAuthService: FirebaseAuthServiceType {

    static var isLoggedIn: Bool {
        currentUser != nil
    }
    
    static var currentUser: FirebaseAuth.User? {
        Auth.auth().currentUser
    }

    func login(email: String, password: String) async -> Result<String, Error> {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            let uid = result.user.uid
            debugPrint("Login: \(uid)")
            return .success((uid))
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
        do {
            try Auth.auth().signOut()
        } catch {
            debugPrint("Error: \(error.localizedDescription)")
        }
    }
}
