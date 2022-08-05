//
//  MockUserService.swift
//  Pika PikaTests
//
//  Created by KoingDev on 4/8/22.
//

import Foundation

@testable import Pika_Pika

final class MockUserService: UserServiceType {
    var mockFetchResult: User?
    var mockSaveResult: Result<Void, Error> = .failure(AppError.userNotFound)
    
    func save(data: [String : Any]) async -> Result<Void, Error> {
        mockSaveResult
    }
    
    func fetch(withUID uid: String) async -> User? {
        mockFetchResult
    }
}
