//
//  EyeCell.swift
//  rokhanPW3
//
//  Created by Roman on 06.10.2021.
//

import UIKit

final class EyeCell : UITableViewCell {
    func setupEye() {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        translatesAutoresizingMaskIntoConstraints = true
        let image = UIImageView(image: UIImage(named: "eye"))
        addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.leadingAnchor.constraint(
            equalTo: self.leadingAnchor,
            constant: CGFloat(Double.random(in: 0...400))
        ).isActive = true
        image.topAnchor.constraint(
            equalTo: self.topAnchor,
            constant: CGFloat(Double.random(in: -20...40))
        ).isActive = true
        image.heightAnchor.constraint(equalToConstant: 20).isActive = true
        image.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }
}
