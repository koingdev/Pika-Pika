//
//  AddNewPostViewController.swift
//  Pika Pika
//
//  Created by KoingDev on 30/7/22.
//

import UIKit
import SnapKit

final class AddNewPostViewController: UIViewController {
    
    var didTappedSubmit: ((String) -> Void)?
    
    
    deinit {
        debugPrint("DEINIT: \(Self.self)")
    }
    
    
    ////////////////////////////////////////////////////////////////
    //MARK: - UI Components
    ////////////////////////////////////////////////////////////////

    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.autocorrectionType = .no
        textView.font = .boldSystemFont(ofSize: 24)
        textView.isEditable = true
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.leading.trailing.bottomMargin.equalToSuperview().inset(20)
        }
        return textView
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.contentVerticalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton()
        button.contentVerticalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        button.tintColor = .systemMint
        return button
    }()
    
    private lazy var stackView: UIView = {
        let stack = UIStackView(arrangedSubviews: [closeButton, submitButton])
        stack.distribution = .equalCentering
        view.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(18)
            make.bottom.equalTo(textView.snp.top)
            make.height.equalTo(44)
        }
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        _ = textView
        _ = stackView
        
        // Action
        closeButton.on(.touchUpInside) { [weak self] _ in
            self?.dismiss(animated: true)
        }
        
        submitButton.on(.touchUpInside) { [weak self] _ in
            if let description = self?.textView.text?.trimmingCharacters(in: .whitespaces),
               !description.isEmpty {
                self?.didTappedSubmit?(description)
                self?.dismiss(animated: true)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
}
