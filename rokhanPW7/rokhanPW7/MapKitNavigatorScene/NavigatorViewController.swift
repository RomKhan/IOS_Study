//
//  NavigatorViewController.swift
//  rokhanPW7
//
//  Created by Roman on 22.01.2022.
//

import UIKit
import CoreLocation
import MapKit

protocol NavigatorViewControllerInputLogic : NavigatorPresenterOutputLogic {
    
}

protocol NavigatorViewControllerOutputLogic {
    
}

class NavigatorViewController : UIViewController, NavigatorViewControllerInputLogic {
    var interactor: NavigatorViewControllerOutputLogic?
    var router: NavigatorRouterLogic?
    private let map: MKMapView = {
        let mapView = MKMapView()
        mapView.layer.masksToBounds = true
        mapView.layer.cornerRadius = 5
        mapView.clipsToBounds = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.showsBuildings = true
        mapView.showsBuildings = true
        mapView.showsUserLocation = true
        return mapView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        configureUI()
    }
    
    private func configureUI() {
        view.addSubview(map)
        map.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        map.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        map.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        map.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}
