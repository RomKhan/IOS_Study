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
    
    private let buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 15
        stack.backgroundColor = UIColor.systemGray6
        stack.distribution = .equalCentering
        stack.layoutMargins = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layer.cornerRadius = 25
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let startLocation = LocationFormView("From")
    let endLocation = LocationFormView("To")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        self.overrideUserInterfaceStyle = .dark
        configureUI()
        setupHideKeyboardOnTap()
    }
    
    private func configureUI() {
        view.addSubview(map)
        map.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        map.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        map.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        map.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        buttonsStack.addArrangedSubview(CustomButtonView(color: .orange.withAlphaComponent(0.8), text: "Go"))
        buttonsStack.addArrangedSubview(CustomButtonView(color: .orange.withAlphaComponent(0.8), text: "Clear"))
        view.addSubview(buttonsStack)
        buttonsStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        buttonsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonsStack.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 10).isActive = true
        buttonsStack.layer.masksToBounds = true
        
        let textStack = UIStackView()
        textStack.axis = .vertical
        view.addSubview(textStack)
        textStack.spacing = 10
        textStack.translatesAutoresizingMaskIntoConstraints = false
        textStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        textStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        textStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10
        ).isActive = true
        textStack.addArrangedSubview(startLocation)
        textStack.addArrangedSubview(endLocation)

    }
}

extension UIViewController {
    /// Call this once to dismiss open keyboards by tapping anywhere in the view controller
    func setupHideKeyboardOnTap() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }

    /// Dismisses the keyboard from self.view
    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
}
