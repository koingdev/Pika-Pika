//
//  AccountViewController.swift
//  Pika Pika
//
//  Created by KoingDev on 30/7/22.
//

import UIKit
import Combine
import SnapKit
import SwiftUI

final class AccountViewController: UIViewController {
    
    private struct Constant {
        static let buttonTitle = "Logout"
    }
    
    private let viewModel: AuthenticationViewModel
    private var cancellable = Set<AnyCancellable>()
    
    init(viewModel: AuthenticationViewModel = AuthenticationViewModel.shared) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint("DEINIT: \(Self.self)")
    }
    
    ////////////////////////////////////////////////////////////////
    //MARK: - UI Components
    ////////////////////////////////////////////////////////////////

    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.crop.circle"))
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
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
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 24)
        view.addSubview(label)
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .tertiaryLabel
        label.font = .systemFont(ofSize: 20)
        view.addSubview(label)
        return label
    }()
    
    private lazy var hStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [profileImageView, nameLabel, emailLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 12
        view.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(12)
            make.top.equalToSuperview().offset(44)
        }
        return stack
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constant.buttonTitle, for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.layer.borderColor = UIColor.systemRed.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 14
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        _ = hStack
        _ = logoutButton
        
        // Full Name
        viewModel.$loggedInUser.receive(on: DispatchQueue.main).sink { [weak self] user in
            self?.nameLabel.text = user?.fullname
            self?.emailLabel.text = user?.email
        }.store(in: &cancellable)
        
        // Action
        logoutButton.on(.touchUpInside) { [weak self] _ in
            self?.viewModel.logout()
            self?.view.window?.rootViewController = LoginViewController()
        }
    }
    
}
