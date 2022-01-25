//
//  NavigatorViewController.swift
//  rokhanPW7
//
//  Created by Roman on 22.01.2022.
//

import UIKit
import MapKit

protocol NavigatorViewControllerInputLogic : NavigatorPresenterOutputLogic {
    
}

protocol NavigatorViewControllerOutputLogic {
    func fetchCoords(start: String?, end: String?)
}

class NavigatorViewController : UIViewController, NavigatorViewControllerInputLogic {
    var interactor: NavigatorViewControllerOutputLogic?
    var destination: MKPlacemark?
    var source: MKPlacemark?
    
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
    
    let goButton : CustomButtonView = {
        let goButton = CustomButtonView(color: .orange.withAlphaComponent(0.8), text: "Go")
        goButton.addTarget(self, action: #selector(goButtonWasPressed), for: .touchDown)
        return goButton
    }()
    
    let clearButton : CustomButtonView = {
        let clearButton = CustomButtonView(color: .orange.withAlphaComponent(0.8), text: "Clear")
        clearButton.addTarget(self, action: #selector(clearButtonWasPressed), for: .touchDown)
        return clearButton
    }()
    
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
        map.delegate = self
        
        buttonsStack.addArrangedSubview(goButton)
        buttonsStack.addArrangedSubview(clearButton)
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
        startLocation.delegate = self
        endLocation.delegate = self
    }
    
    @objc func clearButtonWasPressed(_ sender: UIButton) {
        map.removeAnnotations(map.annotations)
        map.removeOverlays(map.overlays)
        sender.isEnabled = false
        goButton.isEnabled = false
        startLocation.text = ""
        endLocation.text = ""
    }
    
    @objc func goButtonWasPressed(_ sender: UIButton) {
        sender.isEnabled = false
        interactor?.fetchCoords(start: startLocation.text, end: endLocation.text)
    }
    
    func drawPath(directions: MKDirections?, anotations: [MKPointAnnotation]?) {
        goButton.isEnabled = true
        guard let directions = directions, let anotations = anotations
        else { return }
        
        map.removeAnnotations(map.annotations)
        map.removeOverlays(map.overlays)
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            self.map.showAnnotations(anotations, animated: true)
            for route in unwrappedResponse.routes {
                self.map.addOverlay(route.polyline)
                self.map.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
}

extension NavigatorViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        var renderer: MKPolylineRenderer? = nil
        if let anOverlay = overlay as? MKPolyline {
            renderer = MKPolylineRenderer(polyline: anOverlay)
        }
        renderer?.strokeColor = UIColor.systemOrange.withAlphaComponent(0.8)
        renderer?.lineWidth = 5.0
        if let aRenderer = renderer {
            return aRenderer
        }
        return MKOverlayRenderer()
    }
}

extension NavigatorViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resignFirstResponder()
        if startLocation.text != "" && endLocation.text != "" {
            goButtonWasPressed(goButton)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if startLocation.text != "" && endLocation.text != "" {
            goButton.isEnabled = true
            clearButton.isEnabled = true
        }
        else if startLocation.text != "" || endLocation.text != "" {
            clearButton.isEnabled = true
            goButton.isEnabled = false
        }
        else {
            clearButton.isEnabled = false
            goButton.isEnabled = false
        }
    }
}

extension NavigatorViewController {
    func setupHideKeyboardOnTap() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }
    
    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
}
