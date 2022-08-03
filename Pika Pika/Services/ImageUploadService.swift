//
//  ImageUploadService.swift
//  Pika Pika
//
//  Created by KoingDev on 3/8/22.
//

import FirebaseStorage
import UIKit

protocol ImageUploadServiceType {
    func uploadImage(imageData: Data?) async -> String?
    func deleteImage(imageURL: String) async -> Result<Void, Error>
}

struct ImageUploadService: ImageUploadServiceType {
    
    func uploadImage(imageData: Data?) async -> String? {
        guard let imageData = imageData else { return nil }
        
        do {
            let filename = NSUUID().uuidString
            let ref = Storage.storage().reference(withPath: "/profile_image/\(filename)")
            
            _ = try await ref.putDataAsync(imageData)
            let url = try await ref.downloadURL()
            return url.absoluteString
        } catch {
            debugPrint("Error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func deleteImage(imageURL: String) async -> Result<Void, Error> {
        do {
            let ref = Storage.storage().reference(forURL: imageURL)
            try await ref.delete()
            return .success(())
        } catch {
            debugPrint("Error: \(error.localizedDescription)")
            return .failure(error)
        }
    }
}
