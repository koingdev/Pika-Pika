//
//  UserService.swift
//  Pika Pika
//
//  Created by KoingDev on 30/7/22.
//

import FirebaseFirestore
import Firebase

protocol UserServiceType {
    func save(data: [String: Any]) async -> Result<Void, Error>
    func fetch(withUID uid: String) async -> User?
}

final class UserService: UserServiceType {
    func save(data: [String: Any]) async -> Result<Void, Error> {
        do {
            guard let uid = Auth.auth().currentUser?.uid else { return .failure(AppError.userNotFound) }

            try await Firestore.firestore()
                .collection("users")
                .document(uid)
                .setData(data)
            
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func fetch(withUID uid: String) async -> User? {
        do {
            let snapshot = try await Firestore.firestore()
                .collection("users")
                .document(uid)
                .getDocument()

            let user = try snapshot.data(as: User.self)
            return user
        } catch {
            return nil
        }
    }
}
