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
    private let imageUploadService: ImageUploadServiceType
    
    init(
        timelineService: TimelineServiceType = TimelineService(),
        imageUploadService: ImageUploadServiceType = ImageUploadService()
    ) {
        self.timelineService = timelineService
        self.imageUploadService = imageUploadService
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
    
    func post(feed: Feed) async -> Result<Feed, Error> {
        let imageURL = await imageUploadService.uploadImage(imageData: feed.imageData)
        var feed = feed
        feed.imageURL = imageURL    // Update imageURL from Server

        let result = await timelineService.post(feed: feed)
        switch result {
        case .success(let id):
            feed.id = id    // Update auto-id from Server
            return .success((feed))
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func delete(feed: Feed) async -> Result<Void, Error> {
        guard let id = feed.id else {
            return .failure(AppError.documentIdNotFound)
        }
        let result = await timelineService.delete(id: id)
        switch result {
        case .success:
            if let imageURL = feed.imageURL {
                return await imageUploadService.deleteImage(imageURL: imageURL)
            }
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
}
