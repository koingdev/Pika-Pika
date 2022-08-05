//
//  MockImageUploadService.swift
//  Pika PikaTests
//
//  Created by KoingDev on 5/8/22.
//

import Foundation

@testable import Pika_Pika

final class MockImageUploadService: ImageUploadServiceType {
    var mockUploadResult: String?
    var mockDeleteResult: Result<Void, Error> = .failure(AppError.userNotFound)

    func uploadImage(imageData: Data?) async -> String? {
        mockUploadResult
    }
    
    func deleteImage(imageURL: String) async -> Result<Void, Error> {
        mockDeleteResult
    }
}
