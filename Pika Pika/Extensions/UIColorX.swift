//
//  UIColorX.swift
//  Pika Pika
//
//  Created by KoingDev on 29/7/22.
//

import UIKit

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    static let accentColor = UIColor(r: 249, g: 202, b: 36)
}
