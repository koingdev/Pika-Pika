//
//  Post.swift
//  Pika Pika
//
//  Created by KoingDev on 30/7/22.
//

import UIKit
import FirebaseFirestoreSwift
import FirebaseFirestore

struct Feed: Decodable {
    @DocumentID var id: ID?
    let description: String
    var imageURL: String?
    var imageAspectHeight: CGFloat? // Store aspectHeight to avoid computing on client
    let timestamp: Timestamp
    let uid: String
    var fullname: String    // Denormalization for read performance
    
    var belongsToCurrentUser: Bool {
        uid == FirebaseAuthService.currentUser?.uid
    }
    
    /// Use for showing the image immediately after posting
    var imageData: Data?
}

extension Feed {
    static func make(description: String, uid: String, fullname: String) -> Self {
        return Feed(description: description, timestamp: Timestamp(date: Date()), uid: uid, fullname: fullname)
    }
}

extension Data {
    func getImage() -> UIImage? {
        return UIImage(data: self)
    }
}
