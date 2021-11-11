//
//  ArticleCell.swift
//  rokhanPW5
//
//  Created by Roman on 09.11.2021.
//

import UIKit

class ArticleCell : UITableViewCell {
    private var image = UIImageView()
    private var title = UILabel()
    private var articleDescription = UILabel()
    private var descriptionBackground = UIView()
    private var container = UIView()
    private var changePictureQueue = 0
    var ArticleViewModel: ArticleViewModel? {
        willSet {
            image.image = UIImage(named: "error-2.png")
            changePictureQueue += 1
        }
        didSet {
            DispatchQueue.global().async {
                let currentId = self.changePictureQueue
                let img = self.loadImage(url: self.ArticleViewModel?.imageURL)
                if (currentId == self.changePictureQueue) {
                    DispatchQueue.main.async {
                        self.changePictureQueue = 0
                        UIView.transition(with: self.image,
                                          duration: 0.3,
                                          options: .transitionCrossDissolve,
                                          animations: { self.image.image = img },
                                          completion: nil)
                    }
                }
            }
            title.text = ArticleViewModel?.title
            articleDescription.text = ArticleViewModel?.description
            if (ArticleViewModel?.description == "") {
                descriptionBackground.isHidden = true
            }
            else {
                descriptionBackground.isHidden = false
            }
        }
    }
    
    private func loadImage(url : URL?) -> UIImage? {
        guard let anwarpedUrl = url, let data = try? Data(contentsOf: anwarpedUrl) else {
            return UIImage(named: "error-2.png")
        }
        return UIImage(data: data)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value2, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setup() {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray.withAlphaComponent(0.2)
        selectedBackgroundView = view
        backgroundColor = UIColor(white: 1, alpha: 0)
        container.addSubview(image)
        container.addSubview(title)
        container.addSubview(descriptionBackground)
        container.addSubview(articleDescription)
        addSubview(container)
        title.numberOfLines = 2
        title.lineBreakMode = .byTruncatingTail
        title.setContentCompressionResistancePriority(.required, for: .vertical)
        title.textColor = .systemYellow
        title.translatesAutoresizingMaskIntoConstraints = false
        title.topAnchor.constraint(equalTo: container.topAnchor, constant: 10).isActive = true
        title.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10).isActive = true
        title.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10).isActive = true
        title.font = UIFont.boldSystemFont(ofSize: 24)
        title.layer.shadowOpacity = 0.3
        title.layer.shadowColor = UIColor.black.cgColor
        title.layer.shadowRadius = 2
        articleDescription.translatesAutoresizingMaskIntoConstraints = false
        articleDescription.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10).isActive = true
        articleDescription.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10).isActive = true
        articleDescription.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10).isActive = true
        articleDescription.numberOfLines = 3
        articleDescription.font = UIFont.systemFont(ofSize: 14)
        articleDescription.textColor = .black
        image.contentMode = .scaleAspectFill
        image.alpha = 0.8
        image.translatesAutoresizingMaskIntoConstraints = false
        image.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        image.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        image.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        descriptionBackground.translatesAutoresizingMaskIntoConstraints = false
        descriptionBackground.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        descriptionBackground.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        descriptionBackground.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        descriptionBackground.heightAnchor.constraint(equalTo: articleDescription.heightAnchor, constant: 15).isActive = true
        descriptionBackground.backgroundColor = .systemRed.withAlphaComponent(0.7)
        descriptionBackground.layer.shadowOpacity = 1
        descriptionBackground.layer.shadowColor = UIColor.systemRed.cgColor
        descriptionBackground.layer.shadowRadius = 30
        descriptionBackground.layer.shadowOffset = CGSize(width: 0, height: -20)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15).isActive = true
        container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25).isActive = true
        container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25).isActive = true
        heightAnchor.constraint(equalToConstant: 300).isActive = true
        container.clipsToBounds = true
        container.layer.cornerRadius = 15
        container.backgroundColor = .black
        container.layer.borderWidth = 2
        container.layer.borderColor = UIColor.systemRed.cgColor
    }
}
