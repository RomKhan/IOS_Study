//
//  NavigatorViewController.swift
//  rokhanPW7
//
//  Created by Roman on 22.01.2022.
//

import UIKit

protocol NavigatorViewControllerInputLogic : NavigatorPresenterOutputLogic {
    
}

protocol NavigatorViewControllerOutputLogic {
    
}

class NavigatorViewController : UIViewController, NavigatorViewControllerInputLogic {
    var interactor: NavigatorViewControllerOutputLogic?
    var router: NavigatorRouterLogic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
    }
}
