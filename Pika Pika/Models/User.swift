//
//  User.swift
//  Pika Pika
//
//  Created by KoingDev on 30/7/22.
//

import FirebaseFirestoreSwift

typealias ID = String

struct User: Decodable {
    @DocumentID var id: ID?
    let email: String
    let fullname: String
}
