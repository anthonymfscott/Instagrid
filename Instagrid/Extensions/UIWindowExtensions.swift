//
//  UIWindowExtensions.swift
//  Instagrid
//
//  Created by anthonymfscott on 17/04/2020.
//  Copyright © 2020 anthonymfscott. All rights reserved.
//

import UIKit

extension UIWindow {
    static var isPortrait: Bool {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isPortrait ?? false
        } else {
            return UIApplication.shared.statusBarOrientation.isPortrait
        }
    }
}
