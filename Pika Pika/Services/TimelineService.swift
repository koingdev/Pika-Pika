//
//  TimelineService.swift
//  Pika Pika
//
//  Created by KoingDev on 30/7/22.
//

import FirebaseFirestore
import Firebase

protocol TimelineServiceType {
    func post(feed: Feed) async -> Result<Void, Error>
    func fetchAll() async -> Result<[Feed], Error>
    func fetchAll(withUID uid: String) async -> Result<[Feed], Error>
}

final class TimelineService: TimelineServiceType {
    
    func post(feed: Feed) async -> Result<Void, Error> {
        do {
            guard let uid = FirebaseAuthService.currentUser?.uid else { return .failure(AppError.userNotFound) }
            
            let data = [
                "uid": uid,
                "description": feed.description,
                "timestamp": feed.timestamp,
                "fullname": feed.fullname
            ] as [String: Any]
            
            try await Firestore.firestore()
                .collection("feeds")
                .document()
                .setData(data)
            
            return .success(())
        } catch {
            debugPrint("Error: \(error.localizedDescription)")
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
            debugPrint("Error: \(error.localizedDescription)")
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
            debugPrint("Error: \(error.localizedDescription)")
            return .failure(error)
        }
    }
}
