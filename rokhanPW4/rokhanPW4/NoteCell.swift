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
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var showButtonHeightConstrain: NSLayoutConstraint!
    private var updateMeAction: ((Int, Bool) -> ())?
    private var id: Int!
    private var isReuse = false
    private var showMode: Bool = false
    
    override func prepareForReuse() {
        isReuse = true
    }
    
    func SetData(row: Int, updateCellAction: @escaping (Int, Bool) -> ()) {
        id = row
    }
    
    func setup() {
        if !isReuse {
            descriptionLable.layoutSubviews()
            descriptionLable.setContentCompressionResistancePriority(.required, for: .vertical)
            showButton.layer.borderColor = UIColor.systemGray5.cgColor
            showButton.backgroundColor = UIColor.systemGray6
            showButton.addTarget(self, action: #selector(showFullDescription(sender:)), for: .touchDown)
            showButtonHeightConstrain.constant = 0
        }
    }
    
    func setShadow() {
        contentView.layer.cornerRadius = 15
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 6.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        layer.backgroundColor = UIColor.clear.cgColor
    }
    
    func getRandomColor() -> UIColor {
        let x = Int.random(in: 0...8)
        switch x {
        case 0:
            return UIColor.systemRed
        case 1:
            return UIColor.systemOrange
        case 2:
            return UIColor.systemYellow
        case 3:
            return UIColor.systemGreen
        case 4:
            return UIColor.systemBlue
        case 5:
            return UIColor.systemPurple
        case 6:
            return UIColor.systemPink
        case 7:
            return UIColor.systemTeal
        case 8:
            return UIColor.black
        default:
            return UIColor.lightGray
        }
    }
    
    override func systemLayoutSizeFitting(
            _ targetSize: CGSize,
            withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
            verticalFittingPriority: UILayoutPriority) -> CGSize {
        
            // Replace the height in the target size to
            // allow the cell to flexibly compute its height
            var targetSize = targetSize
            targetSize.height = CGFloat.greatestFiniteMagnitude
        
        if descriptionLable.bounds.size.width < descriptionLable.intrinsicContentSize.width || showMode {
            showButtonHeightConstrain.constant = 30
        }
        
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
    
    @objc
    func showFullDescription(sender: Any?) {
        
    }
}
