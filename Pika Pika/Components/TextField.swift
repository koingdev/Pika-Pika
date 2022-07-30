//
//  TextField.swift
//  Pika Pika
//
//  Created by KoingDev on 30/7/22.
//

import Foundation
import UIKit

final class TextField: UITextField {
    
    private let padding = UIEdgeInsets(
        top: 0,
        left: 8,
        bottom: 0,
        right: 8
    )
    private let size = CGSize(width: 24, height: 24)
    
    convenience init(placeholder: String, leftIcon: UIImage?) {
        self.init(frame: .zero)
        self.placeholder = placeholder
        let leftImageView = UIImageView(frame: CGRect(origin: CGPoint(x: padding.left, y: 0), size: size))
        leftImageView.contentMode = .scaleAspectFit
        leftImageView.image = leftIcon
        let container = UIView(frame: CGRect(origin: .zero, size: CGSize(width: leftImageView.frame.width + padding.left, height: size.height)))
        container.addSubview(leftImageView)
        leftViewMode = .always
        leftView = container
        tintColor = .secondaryLabel
        borderStyle = .roundedRect
    }
}
