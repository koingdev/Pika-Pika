//
//  ViewController.swift
//  Pika Pika
//
//  Created by KoingDev on 29/7/22.
//

import UIKit
import SnapKit

class AuthenticationViewController: UIViewController {
    
    private let viewModel = AuthenticationViewModel()


    ////////////////////////////////////////////////////////////////
    //MARK: - UI Components
    ////////////////////////////////////////////////////////////////
    
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "PikachuWelcome"))
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.bottom.equalTo(stackView.snp_topMargin).offset(-20)
            make.centerX.equalToSuperview().offset(20)
            make.height.equalTo(200)
        }
        return imageView
    }()

    private lazy var emailTextField: TextField = {
        let textField = TextField(placeholder: "Email", leftIcon: UIImage(systemName: "envelope.fill"))
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        textField.snp.makeConstraints { $0.height.equalTo(48) }
        return textField
    }()
    
    private lazy var passwordTextField: TextField = {
        let textField = TextField(placeholder: "Password", leftIcon: UIImage(systemName: "lock.fill"))
        textField.isSecureTextEntry = true
        textField.snp.makeConstraints { $0.height.equalTo(48) }
        return textField
    }()
    
    private lazy var forgotPasswordLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 15)
        label.text = "Forgot password?"
        return label
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .accentColor
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Login", for: .normal)
        button.layer.cornerRadius = 16
        button.snp.makeConstraints { $0.height.equalTo(48) }
        return button
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.accentColor, for: .normal)
        button.setTitle("Register Now", for: .normal)
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.accentColor.cgColor
        button.snp.makeConstraints { $0.height.equalTo(48) }
        return button
    }()
    
    private lazy var divider: UIView = {
        let line1 = UIView()
        let line2 = UIView()
        [line1, line2].forEach {
            $0.backgroundColor = .separator
            $0.snp.makeConstraints { make in
                make.height.equalTo(1)
            }
        }
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 15)
        label.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
        label.text = "OR"
        let stack = UIStackView(arrangedSubviews: [line1, label, line2])
        stack.axis = .horizontal
        stack.spacing = 6
        stack.distribution = .fill
        stack.alignment = .center
        line1.snp.makeConstraints { make in
            make.width.equalTo(line2.snp.width)
        }
        return stack
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, forgotPasswordLabel, loginButton, registerButton, divider])
        stack.axis = .vertical
        stack.spacing = 18
        stack.distribution = .fill
        view.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview().offset(60)
        }
        return stack
    }()
    

    ////////////////////////////////////////////////////////////////
    //MARK: - Life Cycle
    ////////////////////////////////////////////////////////////////


    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureActions()
    }
    
    
    ////////////////////////////////////////////////////////////////
    //MARK: - Private
    ////////////////////////////////////////////////////////////////
    
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        _ = stackView
        _ = imageView
    }
    
    private func configureActions() {
        loginButton.on(.touchUpInside) { [unowned self] _ in
            Task {
                let result = await viewModel.login(email: emailTextField.text ?? "", password: passwordTextField.text ?? "")
                resultHandler(result)
            }
        }
        
        registerButton.on(.touchUpInside) { [unowned self] _ in
            Task {
                let result = await viewModel.register(email: emailTextField.text ?? "", password: passwordTextField.text ?? "")
                resultHandler(result)
            }
        }
    }
    
    private func resultHandler(_ result: Result<Void, Error>) {
        switch result {
        case .success():
            let vc = TabBarController()
            view.window?.rootViewController = vc
        case .failure(let error):
//            UIAlertController.errorAlert(message: error.localizedDescription)
            let vc = TabBarController()
            view.window?.rootViewController = vc
        }
    }

}

