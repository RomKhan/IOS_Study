//
//  WebRouter.swift
//  rokhanPW5
//
//  Created by Roman on 11.11.2021.
//

import UIKit

class WebRouter {
    var vc: WebDisplayLogic?
    
    func passDataToWeb(url: URL?) {
        vc?.loadWebView(url: url)
    }
}

