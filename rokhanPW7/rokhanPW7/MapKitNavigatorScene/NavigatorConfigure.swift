//
//  NavigatorSetup.swift
//  rokhanPW7
//
//  Created by Roman on 22.01.2022.
//

import Foundation
import UIKit

class NavigatorConfigure {
    private init() {
        
    }
    
    static func ConfigureNavigator() -> UIViewController {
        let viewControler = NavigatorViewController()
        let interactor = NavigatorInteractor()
        let presenter = NavigatorPresenter()
        let router = NavigatorRouter()
        
        interactor.presenter = presenter
        presenter.viewController = viewControler
        viewControler.interactor = interactor
        viewControler.router = router
        router.navigatorViewController = viewControler
        
        return viewControler
    }
}
