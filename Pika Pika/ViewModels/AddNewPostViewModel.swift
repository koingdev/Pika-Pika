//
//  AddNewPostViewModel.swift
//  Pika Pika
//
//  Created by KoingDev on 3/8/22.
//

import Foundation
import UIKit

final class AddNewPostViewModel {

    func prepareFeed(
        description: String?,
        image: UIImage?,
        authViewModel: AuthenticationViewModel = AuthenticationViewModel.shared
    ) -> Feed? {
        guard let description = description?.trimmingCharacters(in: .whitespaces), !description.isEmpty,
              let loggedInUser = authViewModel.loggedInUser,
              let uid = loggedInUser.id
        else {
            return nil
        }

        var feed = Feed.make(description: description, uid: uid, fullname: loggedInUser.fullname)
        if let image = image {
            feed.imageData = image.jpegData(compressionQuality: 0.7)
            feed.imageAspectHeight = calculateImageAspectSize(size: image.size).height
        }
        return feed
    }
    
    func calculateImageAspectSize(size: CGSize) -> CGSize {
        let padding = CGFloat(12)
        let ratio = size.height / size.width
        let width = (UIScreen.main.bounds.width - padding)
        let aspectHeight = width * ratio
        return CGSize(width: width, height: aspectHeight)
    }
}
