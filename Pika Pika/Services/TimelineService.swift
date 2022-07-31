//
//  TimelineService.swift
//  Pika Pika
//
//  Created by KoingDev on 30/7/22.
//

import FirebaseFirestore
import Firebase

protocol TimelineServiceType {
    func post(feed: Feed) async -> Result<ID, Error>
    func fetchAll() async -> Result<[Feed], Error>
    func delete(id: String) async -> Result<Void, Error>
}

final class TimelineService: TimelineServiceType {
    
    func post(feed: Feed) async -> Result<ID, Error> {
        do {
            guard let uid = FirebaseAuthService.currentUser?.uid else { return .failure(AppError.userNotFound) }
            
            let data = [
                "uid": uid,
                "description": feed.description,
                "timestamp": feed.timestamp,
                "fullname": feed.fullname
            ] as [String: Any]
            
            let document = Firestore.firestore()
                .collection("feeds")
                .document()
            try await document.setData(data)
            return .success(document.documentID)
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
    
    
    func delete(id: String) async -> Result<Void, Error> {
        do {
            try await Firestore.firestore()
                .collection("feeds")
                .document(id)
                .delete()

            return .success(())
        } catch {
            debugPrint("Error: \(error.localizedDescription)")
            return .failure(error)
        }
    }
}
