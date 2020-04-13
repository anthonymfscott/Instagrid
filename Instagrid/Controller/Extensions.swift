//
//  Extensions.swift
//  Instagrid
//
//  Created by anthonymfscott on 13/04/2020.
//  Copyright © 2020 anthonymfscott. All rights reserved.
//

import UIKit

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.editedImage] as? UIImage
        for button in gridViewButtons where button == selectedButton {
            button.setImage(selectedImage, for: .normal)
            selectedButton = nil
            break
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension UIWindow {
    static var isPortrait: Bool {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isPortrait ?? false
        } else {
            return UIApplication.shared.statusBarOrientation.isPortrait
        }
    }
}
