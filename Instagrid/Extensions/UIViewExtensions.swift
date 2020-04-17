//
//  UIViewExtensions.swift
//  Instagrid
//
//  Created by anthonymfscott on 17/04/2020.
//  Copyright © 2020 anthonymfscott. All rights reserved.
//

import UIKit

extension UIView {
    var asUIImage: UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { ctx in
            layer.render(in: ctx.cgContext)
        }
    }
}
