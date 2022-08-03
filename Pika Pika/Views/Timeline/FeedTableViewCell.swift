//
//  FeedTableViewCell.swift
//  Pika Pika
//
//  Created by KoingDev on 30/7/22.
//

import UIKit
import SnapKit
import Kingfisher

final class FeedTableViewCell: UITableViewCell {
    
    var didTappedThreedot: ((UITableViewCell) -> Void)?
    
    ////////////////////////////////////////////////////////////////
    //MARK: - UI Components
    ////////////////////////////////////////////////////////////////

    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.crop.circle"))
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(34)
        }
        imageView.tintAdjustmentMode = .normal
        imageView.tintColor = .systemMint
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
        return label
    }()
    
    private lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        contentView.addSubview(imageView)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        let stack = UIStackView(arrangedSubviews: [hStack, descriptionLabel, postImageView])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .fill
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
            guard let self = self else { return }
            self.didTappedThreedot?(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.image = nil
        postImageView.snp.removeConstraints()
        postImageView.kf.cancelDownloadTask()
    }
    
    func configure(feed: Feed) {
        nameLabel.text = feed.fullname
        descriptionLabel.text = feed.description
        timestampLabel.text = Date().offset(from: feed.timestamp.dateValue())
        
        // Sizing image
        if let imageAspectHeight = feed.imageAspectHeight {
            postImageView.snp.makeConstraints { make in
                make.height.equalTo(imageAspectHeight).priority(.high)  // set priority to below 1000 to resolve constraint warning
            }
        }
        
        // Local image
        if let image = feed.getImage() {
            postImageView.image = image
        }
        
        // Remote image
        if let url = feed.imageURL {
            postImageView.kf.setImage(with: URL(string: url), options: [.transition(.fade(0.1))])
        }
    }
}
