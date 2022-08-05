//
//  MockTimelineService.swift
//  Pika PikaTests
//
//  Created by KoingDev on 5/8/22.
//

import Foundation

@testable import Pika_Pika

final class MockTimelineService: TimelineServiceType {
    var mockPostResult: Result<ID, Error> = .failure(AppError.userNotFound)
    var mockFetchResult: Result<[Feed], Error> = .failure(AppError.userNotFound)
    var mockDeleteResult: Result<Void, Error> = .failure(AppError.userNotFound)
    
    func post(feed: Feed) async -> Result<ID, Error> {
        mockPostResult
    }
    
    func fetchAll() async -> Result<[Feed], Error> {
        mockFetchResult
    }
    
    func delete(id: String) async -> Result<Void, Error> {
        mockDeleteResult
    }
}
