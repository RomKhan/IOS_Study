//
//  NavigatorInteractor.swift
//  rokhanPW7
//
//  Created by Roman on 22.01.2022.
//

import Foundation

protocol NavigatorInteractorInputLogic : NavigatorViewControllerOutputLogic {
    
}

protocol NavigatorInteractorOutputLogic {
    
}

class NavigatorInteractor: NavigatorInteractorInputLogic {
    var presenter: NavigatorInteractorOutputLogic?
}
