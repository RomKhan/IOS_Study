//
//  ArticleConfigure.swift
//  rokhanPW5
//
//  Created by Roman on 09.11.2021.
//

import Foundation

class ArticleConfigure {
    private init() { }
    
    static func configureScene(vc: ArcticleViewController) {
        let presenter = ArticlePresenter()
        let interactor = ArticleIntercator()
        let router = ArticleRouter()
        let worker = ArticleWorker()
        
        interactor.articlePresenter = presenter
        interactor.worker = worker
        presenter.articleVC = vc
        vc.interactor = interactor
        vc.router = router
        router.vc = vc
    }
}
