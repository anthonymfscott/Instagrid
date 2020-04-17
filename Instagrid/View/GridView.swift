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
    @IBOutlet private var topLeftButton: UIButton!
    @IBOutlet private var topRightButton: UIButton!
    @IBOutlet private var bottomLeftButton: UIButton!
    @IBOutlet private var bottomRightButton: UIButton!
    
    var layout: Layout = .oneTwo {
        didSet {
            setLayout()
        }
    }
    
    private func setLayout() {
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
