//
//  NewsTablePresenter.swift
//  rokhanPW5
//
//  Created by Roman on 09.11.2021.
//

import UIKit

protocol ArticlePresenterLogic {
    func presentNews(articles: [ArticleModel])
    func errorPresentNews()
}

class ArticlePresenter : ArticlePresenterLogic {
    
    var articleVC: ArticleDisplayLogic?
    
    private func getArticleViewModels(articles: [ArticleModel]) -> [ArticleViewModel]{
        let articlesModels = articles.compactMap { article -> ArticleViewModel in
            return ArticleViewModel(title: article.title,
                                    description: article.announce,
                                    imageURL: article.img?.url,
                                    articleURL: article.articleUrl)
        }
        return articlesModels
    }
    
    func presentNews(articles: [ArticleModel]) {
        articleVC?.updateCells(articles: getArticleViewModels(articles: articles))
    }
    
    func errorPresentNews() {
        
    }
}
