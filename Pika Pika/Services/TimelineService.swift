//
//  TimelineService.swift
//  Pika Pika
//
//  Created by KoingDev on 30/7/22.
//

import FirebaseFirestore
import Firebase

protocol TimelineServiceType {
    func post(description: String) async -> Result<Void, Error>
    func fetchAll() async -> Result<[Feed], Error>
    func fetchAll(withUID uid: String) async -> Result<[Feed], Error>
}

final class TimelineService {
    
    func post(description: String) async -> Result<Void, Error> {
        do {
            guard let uid = Auth.auth().currentUser?.uid else { return .failure(AppError.userNotFound) }
            
            let data = ["uid": uid,
                        "description": description,
                        "timestamp": Timestamp(date: Date())] as [String: Any]
            
            try await Firestore.firestore()
                .collection("feeds")
                .document()
                .setData(data)
            
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func fetchAll() async -> Result<[Feed], Error> {
        do {
            let snapshot = try await Firestore.firestore()
                .collection("feeds")
                .order(by: "timestamp", descending: true)
                .getDocuments()
            
            let feeds = try snapshot.documents.compactMap { try $0.data(as: Feed.self) }
            return .success(feeds)
        } catch {
            return .failure(error)
        }
    }
    
    func fetchAll(withUID uid: String) async -> Result<[Feed], Error> {
        do {
            let snapshot = try await Firestore.firestore()
                .collection("feeds")
                .whereField("uid", isEqualTo: uid)
                .order(by: "timestamp", descending: true)
                .getDocuments()
            
            let feeds = try snapshot.documents.compactMap { try $0.data(as: Feed.self) }
            return .success(feeds)
        } catch {
            return .failure(error)
        }
    }
}
