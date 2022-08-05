//
//  UIAlertX.swift
//  Pika Pika
//
//  Created by KoingDev on 30/7/22.
//

import UIKit

extension UIAlertController {
    
    // MARK: - Typealias
    
    typealias Alert = UIAlertController
    typealias Action = UIAlertAction
    typealias Block = ((Alert) -> Void)?
    
    // MARK: - Static function
    
    static func errorAlert(message: String) {
        alertOkay(title: "Error", message: message)
    }
    
    static func deleteConfirmation(completion: Block = nil) {
        UIAlertController.Builder()
            .withTitleAndMessage(title: "Delete Post", message: "Are you sure want to delete this?")
            .addCancelAction()
            .addAction(title: "Delete", style: .destructive, completion: completion)
            .show()
    }
    
    static func alertOkay(title: String, message: Any = "", completion: Block = nil) {
        UIAlertController.Builder()
            .withTitleAndMessage(title: title, message: message)
            .addOkAction(completion: completion)
            .show()
    }
    
    static func alertOkayCancel(title: String, message: Any = "", completion: Block = nil) {
        UIAlertController.Builder()
            .withTitleAndMessage(title: title, message: message)
            .addCancelAction()
            .addOkAction(completion: completion)
            .show()
    }
    
    static func alertTextField(title: String,
                               message: Any = "",
                               numberOfField: Int = 1,
                               placeholders: [String] = [],
                               isSecureTexts: [Bool] = [],
                               completion: Block = nil) {
        UIAlertController.Builder()
            .withTitleAndMessage(title: title, message: message)
            .withTextField(numberOfField: numberOfField, placeholders: placeholders, isSecureTexts: isSecureTexts)
            .addCancelAction()
            .addOkAction(completion: completion)
            .show()
    }
    
    // MARK: - Builder
    
    class Builder {
        
        private var alert: Alert! = Alert(title: "", message: "", preferredStyle: .alert)
        
        @discardableResult
        func withTitleAndMessage(title: String = "", message: Any = "") -> Self {
            alert.title = title
            if let message = message as? String {
                alert.message = message
            }
            if let attributedMessage = message as? NSAttributedString {
                alert.setValue(attributedMessage, forKey: "attributedMessage")
            }
            return self
        }
        
        @discardableResult
        func withTextField(numberOfField: Int = 1, placeholders: [String] = [], isSecureTexts: [Bool] = []) -> Self {
            for i in 0 ..< numberOfField {
                alert.addTextField { tf in
                    if placeholders.count == numberOfField {
                        tf.placeholder = placeholders[i]
                    }
                    if isSecureTexts.count == numberOfField {
                        tf.isSecureTextEntry = isSecureTexts[i]
                    }
                }
            }
            return self
        }
        
        @discardableResult
        func addOkAction(completion: Block = nil) -> Self {
            return addAction(title: "Okay", completion: completion)
        }
        
        @discardableResult
        func addCancelAction(completion: Block = nil) -> Self {
            return addAction(title: "Cancel", style: .cancel, completion: completion)
        }
        
        @discardableResult
        func addAction(title: String, style: UIAlertAction.Style = .default, completion: Block = nil) -> Self {
            let action = Action(title: title, style: style) { _ in
                completion?(self.alert)
                self.alert = nil    // Avoid leak
            }
            alert.addAction(action)
            return self
        }
        
        func show(completion: (() -> Void)? = nil) {
            DispatchQueue.main.async {
                UIWindow.rootVC?.present(self.alert, animated: true, completion: completion)
            }
        }
        
    }
    
}
