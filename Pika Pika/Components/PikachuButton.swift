//
//  PikachuButton.swift
//  Pika Pika
//
//  Created by KoingDev on 30/7/22.
//

import UIKit

final class PikachuButton: UIButton {
    
    var animateOnTouch: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    private func setUp() {
        animateOnTouch = true
        layer.cornerRadius = bounds.size.width / 2
        isExclusiveTouch = true
        setBackgroundImage(UIImage(named: "PikachuHead"), for: .normal)
        
        // Animation
        popIn()
    }
    
    private func animateOnTouchBegin() {
        if animateOnTouch {
            UIView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction, .curveEaseOut], animations: {
                self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                self.alpha = 0.7
            })
        }
    }
    
    private func animateOnTouchEnd() {
        if animateOnTouch {
            UIView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction, .curveEaseIn], animations: {
                self.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
                self.alpha = 1.0
            })
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        animateOnTouchBegin()
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if bounds.contains(touch.location(in: self)) {
            animateOnTouchBegin()
        } else {
            animateOnTouchEnd()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        animateOnTouchEnd()
        super.touchesCancelled(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        animateOnTouchEnd()
        super.touchesEnded(touches, with: event)
    }
}
