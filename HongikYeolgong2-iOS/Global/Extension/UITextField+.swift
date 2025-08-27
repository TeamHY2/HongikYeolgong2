//
//  UITextField+.swift
//  HongikYeolgong2-iOS
//
//  Created by 권석기 on 8/17/25.
//

import UIKit

extension UITextField {
    func setPlaceholder(color: UIColor) {
        guard let string = self.placeholder else {
            return
        }
        attributedPlaceholder = NSAttributedString(string: string, attributes: [.foregroundColor: color])
    }
}
