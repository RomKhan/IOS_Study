//
//  ArticleRouter.swift
//  rokhanPW5
//
//  Created by Roman on 09.11.2021.
//

import UIKit

protocol ArticleRouterLogic
{
    func routeToWeb(url: URL?)
}

protocol ArticleDataPassing
{
    
}

class ArticleRouter: ArticleRouterLogic, ArticleDataPassing {
    var vc: ArticleDisplayLogic?
    func routeToWeb(url: URL?) {
        let webVC = WebViewController()
        let webRouter = WebRouter()
        webRouter.vc = webVC
        webRouter.passDataToWeb(url: url)
        vc?.pushControler(vc: webVC)
    }
}

