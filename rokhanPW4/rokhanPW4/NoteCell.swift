//
//  NoteCell.swift
//  rokhanPW4
//
//  Created by Roman on 22.10.2021.
//

import UIKit

class NoteCell: UICollectionViewCell {
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var descriptionLable: UILabel!
    
    func setup() {
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        titleLable.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        titleLable.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        descriptionLable.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        descriptionLable.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
    }
    
    override func systemLayoutSizeFitting(
            _ targetSize: CGSize,
            withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
            verticalFittingPriority: UILayoutPriority) -> CGSize {
            
            // Replace the height in the target size to
            // allow the cell to flexibly compute its height
            var targetSize = targetSize
            targetSize.height = CGFloat.greatestFiniteMagnitude
            
            // The .required horizontal fitting priority means
            // the desired cell width (targetSize.width) will be
            // preserved. However, the vertical fitting priority is
            // .fittingSizeLevel meaning the cell will find the
            // height that best fits the content
            let size = super.systemLayoutSizeFitting(
                targetSize,
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .fittingSizeLevel
            )
            
            return size
        }
}
