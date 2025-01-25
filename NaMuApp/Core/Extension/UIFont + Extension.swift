//
//  UIFont + Extension.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/25/25.
//

import UIKit

extension UIFont {
    
    static func boldItalicFont(_ size: CGFloat) -> UIFont {
        let font = UIFont.systemFont(ofSize: size).fontDescriptor
        let setting: [UIFontDescriptor.TraitKey: Any] = [
            .weight: UIFont.Weight.bold,
            .slant: 0.3
        ]
        let returnFont = font.addingAttributes([.traits: setting])
        return UIFont(descriptor: returnFont, size: size)
    }
    
}

