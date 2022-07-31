//
//  FeedTableViewCell.swift
//  Pika Pika
//
//  Created by KoingDev on 30/7/22.
//

import UIKit
import SnapKit

final class FeedTableViewCell: UITableViewCell {
    
    var didTappedThreedot: (() -> Void)?
    
    ////////////////////////////////////////////////////////////////
    //MARK: - UI Components
    ////////////////////////////////////////////////////////////////

    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.crop.circle"))
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(34)
        }
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = imageView.frame.width / 2
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .label
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 10
        label.textColor = .label
        label.font = .systemFont(ofSize: 15)
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.bottom.equalTo(contentView.snp.bottom)
        }
        return label
    }()
    
    private lazy var timestampLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private(set) lazy var threeDotsButton: UIButton = {
        let button = UIButton()
        button.tintColor = .secondaryLabel
        button.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        return button
    }()
    
    private lazy var hStack: UIStackView = {
        let nameAndTimeStack = UIStackView(arrangedSubviews: [nameLabel, timestampLabel])
        nameAndTimeStack.axis = .vertical
        nameAndTimeStack.distribution = .equalCentering
        let stack = UIStackView(arrangedSubviews: [profileImageView, nameAndTimeStack, threeDotsButton])
        stack.alignment = .top
        stack.spacing = 6
        return stack
    }()
    
    private lazy var vStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [hStack, descriptionLabel])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 6
        contentView.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        _ = vStack
        threeDotsButton.on(.touchUpInside) { [weak self] _ in
            self?.didTappedThreedot?()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(feed: Feed) {
        nameLabel.text = feed.fullname
        descriptionLabel.text = feed.description
        timestampLabel.text = Date().offset(from: feed.timestamp.dateValue())
    }
}