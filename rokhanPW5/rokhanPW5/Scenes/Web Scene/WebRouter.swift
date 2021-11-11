//
//  WebRouter.swift
//  rokhanPW5
//
//  Created by Roman on 11.11.2021.
//

import UIKit

protocol WebRouterLogc {
    func passDataToWeb(url: URL?)
}

class WebRouter : WebRouterLogc {
    
    var vc: WebDisplayLogic?
    
    func passDataToWeb(url: URL?) {
        vc?.loadWebView(url: url)
    }
}

