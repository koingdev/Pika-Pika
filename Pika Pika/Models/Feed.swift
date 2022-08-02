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
    var image: String?
    let timestamp: Timestamp
    let uid: String
    
    // Denormalization for read performance
    var fullname: String
    
    var belongsToCurrentUser: Bool {
        uid == FirebaseAuthService.currentUser?.uid
    }
    
    // Use for showing the image immediately after posting
    var imageData: Data?
    
    func getImage() -> UIImage? {
        guard let imageData = imageData else {
            return nil
        }
        let image = UIImage(data: imageData)
        return image
    }
}

extension Feed {
    static func make(description: String, uid: String, fullname: String) -> Self {
        return Feed(description: description, timestamp: Timestamp(date: Date()), uid: uid, fullname: fullname)
    }
}
