//
//  NewsTablePresenter.swift
//  rokhanPW5
//
//  Created by Roman on 09.11.2021.
//

import UIKit

protocol ArticlePresenterLogic {
    func presentNews()
}

class ArticlePresenter : ArticlePresenterLogic {
    
    weak var articleVC: ArcticleViewController?
    
    func presentNews() {
        
    }
}
