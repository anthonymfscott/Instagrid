//
//  SquareView.swift
//  Instagrid
//
//  Created by anthonymfscott on 16/12/2019.
//  Copyright © 2019 anthonymfscott. All rights reserved.
//

import UIKit

enum Layout {
      case oneTwo, twoOne, twoTwo
  }

class GridView: UIView {
    @IBOutlet var topLeftButton: UIButton!
    @IBOutlet var topRightButton: UIButton!
    @IBOutlet var bottomLeftButton: UIButton!
    @IBOutlet var bottomRightButton: UIButton!
    
    var layout: Layout = .oneTwo {
        didSet {
            setLayout(layout)
        }
    }
    
    private func setLayout(_ layout: Layout) {
        switch layout {
        case .oneTwo:
            topRightButton.isHidden = true
            bottomRightButton.isHidden = false
        case .twoOne:
            topRightButton.isHidden = false
            bottomRightButton.isHidden = true
        case .twoTwo:
            topRightButton.isHidden = false
            bottomRightButton.isHidden = false
        }
    }
}

extension UIView {
    func asImage() -> UIImage {
//        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { ctx in
                layer.render(in: ctx.cgContext)
            }
//        } else {
//            UIGraphicsBeginImageContext(self.frame.size)
//            self.layer.render(in: UIGraphicsGetCurrentContext()!)
//            let image = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//            return UIImage(cgImage: image!.cgImage!)
//        }
    }
}
