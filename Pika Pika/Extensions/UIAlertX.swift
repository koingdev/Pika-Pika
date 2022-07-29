//
//  UIAlertX.swift
//  Pika Pika
//
//  Created by KoingDev on 30/7/22.
//

import UIKit

extension UIAlertController {
    static func errorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        DispatchQueue.main.async {
            UIWindow.rootVC?.present(alert, animated: true)
        }
    }
}
