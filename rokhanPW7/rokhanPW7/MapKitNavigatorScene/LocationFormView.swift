//
//  LovationFormView.swift
//  rokhanPW7
//
//  Created by Roman on 22.01.2022.
//

import UIKit

class LocationFormView : UITextField {
    convenience init(_ baseText: String) {
        self.init()

        backgroundColor = UIColor.systemGray6
        textColor = UIColor.systemGray
        placeholder = baseText
        layer.cornerRadius = 15
        clipsToBounds = false
        font = UIFont.systemFont(ofSize: 15)
        borderStyle = UITextField.BorderStyle.roundedRect
        autocorrectionType = UITextAutocorrectionType.yes
        keyboardType = UIKeyboardType.default
        returnKeyType = UIReturnKeyType.done
        clearButtonMode = UITextField.ViewMode.whileEditing
        contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        translatesAutoresizingMaskIntoConstraints = false
    }
}
