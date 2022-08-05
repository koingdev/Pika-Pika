//
//  TimelineViewModelTest.swift
//  Pika PikaTests
//
//  Created by KoingDev on 5/8/22.
//

import XCTest

@testable import Pika_Pika

class TimelineViewModelTest: XCTestCase {
    
    var viewModel: TimelineViewModel!
    
    // Dependencies
    var mockTimelineService = MockTimelineService()
    var mockImageUploadService = MockImageUploadService()

    override func setUpWithError() throws {
        mockTimelineService = MockTimelineService()
        mockImageUploadService = MockImageUploadService()
        viewModel = TimelineViewModel(timelineService: mockTimelineService, imageUploadService: mockImageUploadService)
    }
    
    func testFetchWithFailureStatus() async {
        // Given
        mockTimelineService.mockFetchResult = .failure(AppError.userNotFound)
        
        // When
        let result = await viewModel.fetch()
        
        // Then
        XCTAssertTrue(result.isEmpty)
    }
    
    func testFetchWithSuccessStatus() async {
        // Given
        mockTimelineService.mockFetchResult = .success([Feed.make(description: "description", uid: "uid", fullname: "fullname")])
        
        // When
        let result = await viewModel.fetch()
        
        // Then
        XCTAssertTrue(result.count == 1)
    }
    
    func testPostWithFailureStatus() async {
        // Given
        let feed = Feed.make(description: "description", uid: "uid", fullname: "fullname")
        mockTimelineService.mockPostResult = .failure(AppError.userNotFound)
        mockImageUploadService.mockUploadResult = nil
        
        // When
        let result = await viewModel.post(feed: feed)
        
        // Then
        switch result {
        case .success(_):
            XCTFail("Expected to get failure.")
        case .failure(let error):
            XCTAssertTrue(error as? AppError == .userNotFound)
        }
    }
    
    func testPostWithSuccessStatus() async {
        // Given
        let feed = Feed.make(description: "description", uid: "uid", fullname: "fullname")
        mockTimelineService.mockPostResult = .success("feed_id")
        mockImageUploadService.mockUploadResult = "image_url"
        
        // When
        let result = await viewModel.post(feed: feed)
        
        // Then
        switch result {
        case .success(let feed):
            XCTAssertTrue(feed.imageURL == "image_url")
            XCTAssertTrue(feed.id == "feed_id")
        case .failure(_):
            XCTFail("Expected to get success.")
        }
    }
    
    func testDeleteWithFailureStatus() async {
        // Given
        var feed = Feed.make(description: "description", uid: "uid", fullname: "fullname")
        feed.id = "id"
        mockTimelineService.mockDeleteResult = .failure(AppError.userNotFound)
        mockImageUploadService.mockDeleteResult = .failure(AppError.userNotFound)
        
        // When
        let result = await viewModel.delete(feed: feed)
        
        // Then
        switch result {
        case .success:
            XCTFail("Expected to get failure.")
        case .failure(let error):
            XCTAssertTrue(error as? AppError == .userNotFound)
        }
    }
    
    func testDeleteWithoutFeedID() async {
        // Given
        var feed = Feed.make(description: "description", uid: "uid", fullname: "fullname")
        feed.id = nil
        
        // When
        let result = await viewModel.delete(feed: feed)
        
        // Then
        switch result {
        case .success:
            XCTFail("Expected to get failure.")
        case .failure(let error):
            XCTAssertTrue(error as? AppError == .documentIdNotFound)
        }
    }
    
    func testDeleteWithSuccessStatus() async {
        // Given
        var feed = Feed.make(description: "description", uid: "uid", fullname: "fullname")
        feed.id = "id"
        mockTimelineService.mockDeleteResult = .success(())
        mockImageUploadService.mockDeleteResult = .success(())
        
        // When
        let result = await viewModel.delete(feed: feed)
        
        // Then
        switch result {
        case .success:
            XCTAssertTrue(true)
        case .failure(_):
            XCTFail("Expected to get success.")
        }
    }

}
