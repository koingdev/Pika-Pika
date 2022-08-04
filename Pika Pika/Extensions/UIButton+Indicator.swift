//
//  UIButton+Indicator.swift
//  Pika Pika
//
//  Created by KoingDev on 4/8/22.
//

import UIKit

extension UIButton {
    func loadingIndicator(
        show: Bool,
        style: UIActivityIndicatorView.Style = .medium,
        color: UIColor = .white,
        tag: Int = 10042017
    ) {
        if show {
            isEnabled = false
            titleLabel?.alpha = 0
            let indicator = UIActivityIndicatorView(style: style)
            indicator.color = color
            indicator.center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
            indicator.tag = tag
            addSubview(indicator)
            indicator.startAnimating()
        } else {
            isEnabled = true
            titleLabel?.alpha = 1
            if let indicator = viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
}
