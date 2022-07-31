//
//  RegisterViewController.swift
//  Pika Pika
//
//  Created by KoingDev on 30/7/22.
//

import UIKit
import SnapKit

class RegisterViewController: LoginViewController {
    
    private let viewModel: AuthenticationViewModel
    
    override init(viewModel: AuthenticationViewModel) {
        self.viewModel = viewModel
        super.init(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    ////////////////////////////////////////////////////////////////
    //MARK: - Override
    ////////////////////////////////////////////////////////////////

    override var authenticateButtonTitle: String {
        "Register"
    }

    override var bottomLabelText: (String, String) {
        ("Already have an account?", "Login")
    }
    
    override var stackChildrens: [UIView] {
        [emailTextField, fullnameTextField, passwordTextField, authenticateButton]
    }
    
    override func authenticate() {
        Task {
            let result = await viewModel.register(email: emailTextField.text ?? "", password: passwordTextField.text ?? "", fullname: fullnameTextField.text ?? "")
            resultHandler(result)
        }
    }
    
    override func goNextScreen() {
       let vc = LoginViewController(viewModel: viewModel)
       view.window?.rootViewController = vc
   }

    ////////////////////////////////////////////////////////////////
    //MARK: - UI Components
    ////////////////////////////////////////////////////////////////
    
    private lazy var fullnameTextField: TextField = {
        let textField = TextField(placeholder: "Fullname", leftIcon: UIImage(systemName: "person.fill"))
        textField.snp.makeConstraints { $0.height.equalTo(48) }
        return textField
    }()

}


