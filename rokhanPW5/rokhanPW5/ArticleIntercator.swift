//
//  NewsTableInteractor.swift
//  rokhanPW5
//
//  Created by Roman on 09.11.2021.
//

import Foundation

protocol ArticleBuisnessLogic{
    var articles: [ArticleModel]? { get }
}

protocol ArticleDataStore {
    func loadFreshNews()
    func loadMoreNews()
}

class ArticleIntercator : ArticleBuisnessLogic, ArticleDataStore {
    var articlePresenter: ArticlePresenterLogic?
    var worker: ArticleWorkerLogic?
    var articles: [ArticleModel]? {
        didSet {
            articlePresenter?.presentNews()
        }
    }
    
    func loadFreshNews() {
        
    }
    
    func loadMoreNews() {
        
    }
    
    
}
