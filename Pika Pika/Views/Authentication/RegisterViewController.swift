//
//  RegisterViewController.swift
//  Pika Pika
//
//  Created by KoingDev on 30/7/22.
//

import UIKit
import SnapKit

class RegisterViewController: LoginViewController {
    
    private struct Constant {
        static let registerButtonTitle = "Register"
        static let bottomText = ("Already have an account?", "Login")
        static let fullnamePlaceholder = "Fullname"
        static let fullnameImageName = "person.fill"
    }
    
    
    ////////////////////////////////////////////////////////////////
    //MARK: - Override
    ////////////////////////////////////////////////////////////////

    override var authenticateButtonTitle: String {
        Constant.registerButtonTitle
    }

    override var bottomLabelText: (String, String) {
        Constant.bottomText
    }
    
    override var stackChildrens: [UIView] {
        [emailTextField, fullnameTextField, passwordTextField, authenticateButton]
    }
    
    override func authenticate() {
        Task {
            authenticateButton.loadingIndicator(show: true)
            let result = await viewModel.register(email: emailTextField.text ?? "", password: passwordTextField.text ?? "", fullname: fullnameTextField.text ?? "")
            authenticateButton.loadingIndicator(show: false)
            resultHandler(result)
        }
    }
    
    override func goNextScreen() {
       let vc = LoginViewController()
       view.window?.rootViewController = vc
   }

    ////////////////////////////////////////////////////////////////
    //MARK: - UI Components
    ////////////////////////////////////////////////////////////////
    
    private lazy var fullnameTextField: TextField = {
        let textField = TextField(placeholder: Constant.fullnamePlaceholder, leftIcon: UIImage(systemName: Constant.fullnameImageName))
        textField.autocorrectionType = .no
        textField.snp.makeConstraints { $0.height.equalTo(48) }
        return textField
    }()

}


