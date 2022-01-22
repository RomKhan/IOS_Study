//
//  NavigatorPresenter.swift
//  rokhanPW7
//
//  Created by Roman on 22.01.2022.
//

import UIKit

protocol NavigatorPresenterInputLogic : NavigatorInteractorOutputLogic {
    
}

protocol NavigatorPresenterOutputLogic {
    
}

class NavigatorPresenter : NavigatorPresenterInputLogic {
    var viewController: NavigatorPresenterOutputLogic?
}
