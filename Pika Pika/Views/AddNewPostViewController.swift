//
//  AddNewPostViewController.swift
//  Pika Pika
//
//  Created by KoingDev on 30/7/22.
//

import UIKit
import SnapKit

final class AddNewPostViewController: UIViewController {
    
    var didTappedSubmit: ((Feed) -> Void)?
    private var imagePicker: ImagePicker!
    private let viewModel = AddNewPostViewModel()
    
    deinit {
        debugPrint("DEINIT: \(Self.self)")
    }
    
    
    ////////////////////////////////////////////////////////////////
    //MARK: - UI Components
    ////////////////////////////////////////////////////////////////

    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.autocorrectionType = .no
        textView.textContainer.maximumNumberOfLines = 10
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.font = .boldSystemFont(ofSize: 24)
        textView.isEditable = true
        textView.delegate = self
        let bar = UIToolbar(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))
        let photoButtonItem = UIBarButtonItem(image: UIImage(systemName: "photo"), style: .plain, target: self, action: #selector(choosePhoto))
        let cameraButtonItem = UIBarButtonItem(image: UIImage(systemName: "camera"), style: .plain, target: self, action: #selector(openCamera))
        bar.items = [cameraButtonItem, photoButtonItem]
        bar.sizeToFit()
        textView.inputAccessoryView = bar
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(imageView.snp.top).offset(-20)
            make.height.equalTo(52)
        }
        return textView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.height.width.equalTo(UIScreen.main.bounds.width * 0.6)
        }
        return imageView
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
        button.contentVerticalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
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
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
    private func setup() {
        view.backgroundColor = .white
        _ = textView
        _ = stackView
        _ = imageView
        imagePicker = ImagePicker(presentationController: self) { [weak self] selectedImage in
            self?.imageView.image = selectedImage
            self?.textView.becomeFirstResponder()
        }

        closeButton.on(.touchUpInside) { [weak self] _ in
            self?.dismiss(animated: true)
        }
        
        submitButton.on(.touchUpInside) { [weak self] _ in
            if let feed = self?.viewModel.prepareFeed(description: self?.textView.text, image: self?.imageView.image) {
                self?.didTappedSubmit?(feed)
                self?.dismiss(animated: true)
            }
        }
    }
    
    @objc private func choosePhoto() {
        imagePicker.present(.photoLibrary)
    }
    
    @objc private func openCamera() {
        imagePicker.present(.camera)
    }
}


////////////////////////////////////////////////////////////////
//MARK: - Auto-sizing TextView
////////////////////////////////////////////////////////////////

extension AddNewPostViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.size.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        for constraint in textView.constraints where constraint.firstAttribute == .height {
            constraint.constant = max(CGFloat(52), estimatedSize.height)
        }
    }
}
