//
//  UIViewX.swift
//  Pika Pika
//
//  Created by KoingDev on 30/7/22.
//

import UIKit

extension UIView {
    func bounce(duration: TimeInterval = 0.8, completion: (() -> Void)? = nil) {
        transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 6, options: .allowUserInteraction, animations: {
            // reset to default
            self.transform = CGAffineTransform.identity
        }, completion: { _ in
            completion?()
        })
    }
    
    func popIn(duration: TimeInterval = 0.8, completion: (() -> Void)? = nil) {
        transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: { _ in
            completion?()
        })
    }
}
