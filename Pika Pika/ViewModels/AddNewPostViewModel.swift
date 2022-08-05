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
            feed.imageData = image.jpegData(compressionQuality: 0.5)
            feed.imageAspectHeight = calculateImageAspectHeight(image: image)
        }
        return feed
    }
    
    private func calculateImageAspectHeight(image: UIImage) -> CGFloat {
        let ratio = image.size.height / image.size.width
        let aspectHeight = (UIScreen.main.bounds.width - 12) * ratio
        return aspectHeight
    }
}
