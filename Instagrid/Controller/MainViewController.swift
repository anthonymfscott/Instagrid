//
//  ViewController.swift
//  Instagrid
//
//  Created by anthonymfscott on 06/11/2019.
//  Copyright © 2019 anthonymfscott. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var gridView: GridView!
    @IBOutlet var gridViewButtons: [UIButton]!
    @IBOutlet var layoutChoiceButtons: [UIButton]!
    
    var selectedButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for button in gridViewButtons {
            button.imageView?.contentMode = .scaleAspectFill
        }
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragGridView(_:)))
        gridView.addGestureRecognizer(panGestureRecognizer)
    }

    @IBAction func layoutChoiceButtonTapped(_ sender: UIButton) {
        for button in layoutChoiceButtons {
            button.isSelected = false
        }
        
        sender.isSelected = true
        
        selectLayout(number: sender.tag)
    }
    
    private func selectLayout(number: Int) {
        switch number {
        case 1:
            gridView.layout = .oneTwo
        case 2:
            gridView.layout = .twoOne
        default:
            gridView.layout = .twoTwo
        }
    }
    
    @IBAction func gridButtonTapped(_ sender: UIButton) {
        selectedButton = sender
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true)
    }
    
    @objc func dragGridView(_ sender: UIPanGestureRecognizer) {
        print(sender.translation(in: view))
        
        switch sender.state {
        case .began, .changed:
            moveGridViewWith(gesture: sender)
        case .ended, .cancelled:
            // share if the swipe has past a certain point in Portrait mode
            if UIWindow.isPortrait && sender.translation(in: view).y <= -60 {
                share()
            }
            // ditto in Landscape mode
            else if !UIWindow.isPortrait && sender.translation(in: view).x <= -110  {
                share()
            }
            // otherwise just reset the position of the grid
            else {
                resetPosition()
            }
        default:
            break
        }
    }
    
    private func moveGridViewWith(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: gridView)
        
        // limit to an upward swipe in Portrait and to a left swipe in Landscape
        if UIWindow.isPortrait {
            if translation.y < 0 {
                gridView.transform = CGAffineTransform(translationX: 0, y: translation.y)
            }
        } else {
            if translation.x < 0 {
                gridView.transform = CGAffineTransform(translationX: translation.x, y: 0)
            }
        }
    }
   
    private func share() {
        finishUpTranslation()

        let vc = UIActivityViewController(activityItems: [gridView.asUIImage, "Made with Instagrid"], applicationActivities: [])
        vc.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in self.reset()
        }
        
        present(vc, animated: true)
    }
    
    private func reset() {
        resetPosition()
        
        for button in self.gridViewButtons {
            button.setImage(UIImage(named: "Plus"), for: .normal)
        }
    }
    
    private func resetPosition() {
        UIView.animate(withDuration: 0.5, animations: {
            self.gridView.transform = .identity
        })
    }
    
    private func finishUpTranslation() {
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        
        var translationTransform: CGAffineTransform
        
        if UIWindow.isPortrait {
            translationTransform = CGAffineTransform(translationX: 0, y: -screenHeight)
        } else {
            translationTransform = CGAffineTransform(translationX: -screenWidth, y: 0)
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.gridView.transform = translationTransform
        })
    }
}

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
