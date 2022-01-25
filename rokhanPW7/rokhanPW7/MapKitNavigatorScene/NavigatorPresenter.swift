//
//  NavigatorPresenter.swift
//  rokhanPW7
//
//  Created by Roman on 22.01.2022.
//

import UIKit
import MapKit

protocol NavigatorPresenterInputLogic : NavigatorInteractorOutputLogic {

}

protocol NavigatorPresenterOutputLogic {
    func drawPath(directions: MKDirections?, anotations: [MKPointAnnotation]?)
}

class NavigatorPresenter : NavigatorPresenterInputLogic {
    var viewController: NavigatorPresenterOutputLogic?
    
    func buildPath(coords: [CLLocationCoordinate2D]) {
        guard (coords.count == 2) else {
            viewController?.drawPath(directions: nil, anotations: nil)
            return
        }
        
        let sourceLocation = MKPlacemark(coordinate: coords[0], addressDictionary: nil)
        let sourceAnotition = MKPointAnnotation()
        sourceAnotition.coordinate = sourceLocation.coordinate
        sourceAnotition.title = "A"
        
        let destonitionLocation = MKPlacemark(coordinate: coords[1], addressDictionary: nil)
        let destonitionAnotition = MKPointAnnotation()
        destonitionAnotition.coordinate = destonitionLocation.coordinate
        destonitionAnotition.title = "B"
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: sourceLocation)
        request.destination = MKMapItem(placemark: destonitionLocation)
        request.requestsAlternateRoutes = true
        request.transportType = .automobile

        let directions = MKDirections(request: request)
        viewController?.drawPath(directions: directions, anotations: [sourceAnotition, destonitionAnotition])
    }
}
