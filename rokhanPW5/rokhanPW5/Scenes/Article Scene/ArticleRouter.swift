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
    func routeToShareMenu(url: URL?)
}

class ArticleRouter: ArticleRouterLogic {
    var vc: ArticleDisplayLogic?
    /// Перенаправление к webViewControllerю
    func routeToWeb(url: URL?) {
        let webVC = WebViewController()
        let webRouter = WebRouter()
        webRouter.vc = webVC
        webRouter.passDataToWeb(url: url)
        vc?.pushControler(vc: webVC)
    }
    
    /// Перенаправление к share окну.
    func routeToShareMenu(url: URL?) {
        guard let urlIsNotNil = url else { return }
        let shareVC = UIActivityViewController(
            activityItems: [
                urlIsNotNil
            ],
            applicationActivities: nil)
        vc?.pushControler(vc: shareVC)
    }
}

