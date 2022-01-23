//
//  CustomButtonView.swift
//  rokhanPW7
//
//  Created by Roman on 22.01.2022.
//

import UIKit

class CustomButtonView: UIButton {
    
    convenience init(color: UIColor, text: String) {
        self.init()
        backgroundColor = color
        self.setTitle(text, for: .normal)
        self.layer.cornerRadius = 20
        isEnabled = false
        setTitleColor(.gray, for: .disabled)
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 12).isActive = true
        heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 12).isActive = true
    }
}
