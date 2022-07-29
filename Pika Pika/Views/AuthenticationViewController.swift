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
    

    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        textField.borderStyle = .roundedRect
        textField.placeholder = "Email"
        textField.snp.makeConstraints { $0.height.equalTo(48) }
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.placeholder = "Password"
        textField.snp.makeConstraints { $0.height.equalTo(48) }
        return textField
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
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton, registerButton])
        stack.axis = .vertical
        stack.spacing = 18
        stack.distribution = .equalSpacing
        view.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
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
            let vc = TimelineViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        case .failure(let error):
            UIAlertController.errorAlert(message: error.localizedDescription)
        }
    }

}

