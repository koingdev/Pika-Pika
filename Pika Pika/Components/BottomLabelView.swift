//
//  BottomLabelView.swift
//  Pika Pika
//
//  Created by KoingDev on 30/7/22.
//

import UIKit
import SnapKit

final class BottomLabelView: UIView {
    private let text: (String, String)
    var didTapped: (() -> Void)?
    
    init(text: (String, String)) {
        self.text = text
        super.init(frame: .zero)
        
        // Set up
        let leftLabel = UILabel()
        leftLabel.textColor = .secondaryLabel
        leftLabel.font = .systemFont(ofSize: 15)
        leftLabel.text = text.0
        
        let rightButton = UIButton()
        rightButton.setTitleColor(.secondaryLabel, for: .normal)
        rightButton.setTitle(text.1, for: .normal)
        rightButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
        rightButton.on(.touchUpInside) { [weak self] _ in
            self?.didTapped?()
        }
        
        let stack = UIStackView(arrangedSubviews: [leftLabel, rightButton])
        stack.spacing = 4
        stack.distribution = .fill
        stack.alignment = .center
        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
