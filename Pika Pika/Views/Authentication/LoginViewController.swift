//
//  ViewController.swift
//  Pika Pika
//
//  Created by KoingDev on 29/7/22.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {
    
    private struct Constant {
        static let imageViewName = "PikachuWelcome"
        static let emailPlaceholder = "Email"
        static let emailImageName = "envelope.fill"
        static let passwordPlaceholder = "Password"
        static let passwordImageName = "lock.fill"
        static let loginButtonTitle = "Login"
        static let bottomText = ("Don't have an account?", "Register")
    }
    
    let viewModel: AuthenticationViewModel
    
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
    //MARK: - Override Me
    ////////////////////////////////////////////////////////////////

    open var authenticateButtonTitle: String {
        Constant.loginButtonTitle
    }

    open var bottomLabelText: (String, String) {
        Constant.bottomText
    }
    
    open var stackChildrens: [UIView] {
        [emailTextField, passwordTextField, authenticateButton]
    }
    
    open func authenticate() {
        Task {
            authenticateButton.loadingIndicator(show: true)
            let result = await viewModel.login(email: emailTextField.text ?? "", password: passwordTextField.text ?? "")
            authenticateButton.loadingIndicator(show: false)
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
        let imageView = UIImageView(image: UIImage(named: Constant.imageViewName))
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
        let textField = TextField(placeholder: Constant.emailPlaceholder, leftIcon: UIImage(systemName: Constant.emailImageName))
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        textField.snp.makeConstraints { $0.height.equalTo(48) }
        return textField
    }()
    
    private(set) lazy var passwordTextField: TextField = {
        let textField = TextField(placeholder: Constant.passwordPlaceholder, leftIcon: UIImage(systemName: Constant.passwordImageName))
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
        setupUI()
        setupAction()
        setupKeyboardObserver()
    }
    
    ////////////////////////////////////////////////////////////////
    //MARK: - Private
    ////////////////////////////////////////////////////////////////
    
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        _ = stackView
        _ = imageView
    }
    
    private func setupAction() {
        let tapOutsideGesture = UITapGestureRecognizer(target: self, action: #selector(tapOutsideRecognized))
        view.addGestureRecognizer(tapOutsideGesture)
        
        authenticateButton.on(.touchUpInside) { [weak self] _ in
            self?.authenticate()
        }
        
        bottomLabelView.didTapped = { [weak self] in
            self?.goNextScreen()
        }
    }
    
    /// Observe the keyboard to automatically push the content to prevent keyboard hiding the content
    private func setupKeyboardObserver() {
        // Will Show
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main) { [weak self] notification in
            guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
                return
            }
            self?.animateFrame(-keyboardFrame.height / 2)
        }
        
        // Will Hide
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main) { [weak self] _ in
            self?.animateFrame(0)
        }
    }
    
    private func animateFrame(_ y: CGFloat) {
        guard view.frame.origin.y != y else { return }
        UIView.animate(withDuration: 0, delay: 0, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.view.frame.origin.y = y
        })
    }
    
    @objc private func tapOutsideRecognized() {
        view.endEditing(true)
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

