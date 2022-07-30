//
//  User.swift
//  Pika Pika
//
//  Created by KoingDev on 30/7/22.
//

import FirebaseFirestoreSwift

struct User: Decodable {
    @DocumentID var id: String?
    let username: String
    let fullname: String
    let profileImageURL: String
    let email: String
}
