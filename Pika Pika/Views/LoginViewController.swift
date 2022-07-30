//
//  ViewController.swift
//  Pika Pika
//
//  Created by KoingDev on 29/7/22.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {
    
    private let viewModel: AuthenticationViewModel
    
    init(viewModel: AuthenticationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    ////////////////////////////////////////////////////////////////
    //MARK: - Override Me
    ////////////////////////////////////////////////////////////////

    open var authenticateButtonTitle: String {
        "Login"
    }

    open var bottomLabelText: (String, String) {
        ("Don't have an account?", "Register")
    }
    
    open var stackChildrens: [UIView] {
        [emailTextField, passwordTextField, authenticateButton]
    }
    
    open func authenticate() {
        Task {
            let result = await viewModel.login(email: emailTextField.text ?? "", password: passwordTextField.text ?? "")
            resultHandler(result)
        }
    }
    
    open func goNextScreen() {
        let vc = RegisterViewController(viewModel: viewModel)
        view.window?.rootViewController = vc
    }

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

    private(set) lazy var emailTextField: TextField = {
        let textField = TextField(placeholder: "Email", leftIcon: UIImage(systemName: "envelope.fill"))
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        textField.snp.makeConstraints { $0.height.equalTo(48) }
        return textField
    }()
    
    private(set) lazy var passwordTextField: TextField = {
        let textField = TextField(placeholder: "Password", leftIcon: UIImage(systemName: "lock.fill"))
        textField.isSecureTextEntry = true
        textField.snp.makeConstraints { $0.height.equalTo(48) }
        return textField
    }()
    
    private(set) lazy var authenticateButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .accentColor
        button.setTitleColor(.white, for: .normal)
        button.setTitle(authenticateButtonTitle, for: .normal)
        button.layer.cornerRadius = 16
        button.snp.makeConstraints { $0.height.equalTo(48) }
        return button
    }()
    
    private lazy var bottomLabelView: BottomLabelView = {
        let bottomView = BottomLabelView(text: bottomLabelText)
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.snp.bottomMargin)
        }
        return bottomView
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: stackChildrens)
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
        authenticateButton.on(.touchUpInside) { [unowned self] _ in
            authenticate()
        }
        
        bottomLabelView.didTapped = { [unowned self] in
            goNextScreen()
        }
    }
    
    func resultHandler(_ result: Result<Void, Error>) {
        switch result {
        case .success():
            let vc = TabBarController()
            view.window?.rootViewController = vc
        case .failure(let error):
            UIAlertController.errorAlert(message: error.localizedDescription)
        }
    }

}

