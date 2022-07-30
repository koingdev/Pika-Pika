//
//  Post.swift
//  Pika Pika
//
//  Created by KoingDev on 30/7/22.
//

import FirebaseFirestoreSwift
import FirebaseFirestore

struct Feed: Decodable {
    @DocumentID var id: String?
    let description: String
    let timestamp: Timestamp
    let uid: String
    
    var user: User?
}

extension Feed {
    static func make(description: String, uid: String) -> Self {
        return Feed(description: description, timestamp: Timestamp(date: Date()), uid: uid)
    }
}
