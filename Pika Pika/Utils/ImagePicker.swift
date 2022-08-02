//
//  ImagePicker.swift
//  Pika Pika
//
//  Created by KoingDev on 2/8/22.
//

import UIKit

final class ImagePicker: NSObject {
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private let didSelect: (UIImage) -> Void
    
    init(presentationController: UIViewController, didSelect: @escaping (UIImage) -> Void) {
        self.pickerController = UIImagePickerController()
        self.didSelect = didSelect
        super.init()
        self.presentationController = presentationController
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = false
        self.pickerController.mediaTypes = ["public.image"]
    }
    
    func present() {
        let type: UIImagePickerController.SourceType = .photoLibrary
        guard UIImagePickerController.isSourceTypeAvailable(type) else { return }
        pickerController.sourceType = type
        presentationController?.present(pickerController, animated: true)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else { return }
        didSelect(image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
