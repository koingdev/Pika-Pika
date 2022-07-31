//
//  TimelineViewModel.swift
//  Pika Pika
//
//  Created by KoingDev on 30/7/22.
//

import Foundation
import UIKit

final class TimelineViewModel {
    
    private let timelineService: TimelineServiceType
    
    init(timelineService: TimelineServiceType = TimelineService()) {
        self.timelineService = timelineService
    }
    
    func fetch() async -> [Feed] {
        let result = await timelineService.fetchAll()
        switch result {
        case .success(let feeds):
            return feeds
        case .failure(_):
            return []
        }
    }
    
    func post(feed: Feed) async -> Result<Void, Error> {
        return await timelineService.post(feed: feed)
    }
    
    func delete(feed: Feed) async -> Result<Void, Error> {
        guard let id = feed.id else {
            return .failure(AppError.documentIdNotFound)
        }
        return await timelineService.delete(id: id)
    }
}
