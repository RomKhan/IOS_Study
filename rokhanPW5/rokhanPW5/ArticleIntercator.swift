//
//  NewsTableInteractor.swift
//  rokhanPW5
//
//  Created by Roman on 09.11.2021.
//

import Foundation

protocol ArticleBuisnessLogic{
    var articles: [ArticleModel]{ get set }
}

protocol ArticleDataStore {
    func loadFreshNews()
    func loadMoreNews()
}

class ArticleIntercator : ArticleBuisnessLogic, ArticleDataStore {
    var articlePresenter: ArticlePresenterLogic?
    var worker: ArticleWorkerLogic?
    var pageNumber = 1
    var oldLenghtOfArticlesList = 0
    var articles: [ArticleModel] = [] {
        willSet {
            oldLenghtOfArticlesList = articles.count
        }
        didSet {
            if oldLenghtOfArticlesList == 0 || oldLenghtOfArticlesList >= articles.count {
                articlePresenter?.presentNews(articles: articles)
            }
            else {
                var appendedArticles: [ArticleModel] = []
                for i in (oldLenghtOfArticlesList)...(articles.count - 1) {
                    appendedArticles.append(articles[i])
                }
                articlePresenter?.presentNews(articles: appendedArticles)
            }
        }
    }
    
    func loadFreshNews() {
        articles.removeAll()
        pageNumber = 1
        worker?.fetchNews(4, pageNumber,
                          success: { [weak self] page in
                            self?.articles = page.news ?? []
                            self?.pageNumber += 1
                          },
                          fail: { [weak self] in
                            self?.articlePresenter?.errorPresentNews()
                          })
    }
    
    func loadMoreNews() {
        worker?.fetchNews(4, pageNumber,
                          success: { [weak self] page in
                            self?.articles += page.news ?? []
                            self?.pageNumber += 1
                          },
                          fail: { [weak self] in
                            self?.articlePresenter?.errorPresentNews()
                          })
    }
    
    
}
