//
//  ViewController.swift
//  Instagrid
//
//  Created by anthonymfscott on 06/11/2019.
//  Copyright © 2019 anthonymfscott. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: Settings
    
    @IBOutlet private weak var gridView: GridView!
    @IBOutlet var gridViewButtons: [UIButton]!
    @IBOutlet private var layoutChoiceButtons: [UIButton]!
    
    var selectedButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for button in gridViewButtons {
            button.setImage(UIImage(named: "Plus"), for: .normal)
            button.imageView?.contentMode = .scaleAspectFill
        }
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragGridView(_:)))
        gridView.addGestureRecognizer(panGestureRecognizer)
    }
    
    // MARK: Layout Setup
    
    @IBAction private func layoutChoiceButtonTapped(_ sender: UIButton) {
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

    // MARK: Interaction
    
    @IBAction private func gridButtonTapped(_ sender: UIButton) {
        selectedButton = sender
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true)
    }
    
    @objc private func dragGridView(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began, .changed:
            moveGridViewWith(gesture: sender)
        case .ended, .cancelled:
            // share if the swipe has passed a certain point in Portrait mode
            if UIWindow.isPortrait && sender.translation(in: view).y <= -60 {
                share()
            }
            // ditto in Landscape mode
            else if !UIWindow.isPortrait && sender.translation(in: view).x <= -110  {
                share()
            }
            // otherwise just reset the grid's position
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
        guard isFinalGridConform() else { return }
        
        completeTranslation()

        let vc = UIActivityViewController(activityItems: [gridView.asUIImage, "Made with Instagrid"], applicationActivities: [])
        vc.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            if completed {
                self.resetAll()
            } else {
                self.resetPosition()
            }
        }
        present(vc, animated: true)
    }
    
    private func completeTranslation() {
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
    
    private func resetAll() {
        resetPosition()
        
        for button in self.gridViewButtons {
            button.setImage(UIImage(named: "Plus"), for: .normal)
        }
    }
    
    private func resetPosition(_: UIAlertAction? = nil) {
        UIView.animate(withDuration: 0.5, animations: {
            self.gridView.transform = .identity
        })
    }
    
    private func isFinalGridConform() -> Bool {
        for button in gridViewButtons where button.isHidden == false {
            if button.image(for: .normal) == UIImage(named: "Plus") {
                let ac = UIAlertController(title: "Unable to share", message: "Your grid is missing pictures!", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: self.resetPosition))
                present(ac, animated: true)
                return false
            }
        }
        
        return true
    }
}
