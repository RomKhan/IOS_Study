//
//  NavigatorInteractor.swift
//  rokhanPW7
//
//  Created by Roman on 22.01.2022.
//

import Foundation
import CoreLocation

protocol NavigatorInteractorInputLogic : NavigatorViewControllerOutputLogic {
    
}

protocol NavigatorInteractorOutputLogic {
    func buildPath(coords: [CLLocationCoordinate2D])
}

class NavigatorInteractor: NavigatorInteractorInputLogic {
    var presenter: NavigatorInteractorOutputLogic?
    var coordinates: [CLLocationCoordinate2D] = []
    
    func fetchCoords(start: String?, end: String?) {
        guard
            let first = start,
            let second = end,
            first != second
        else {
            return
        }
        
        let group = DispatchGroup()
        group.enter()
        getCoordinateFrom(address: first, completion: { [weak self] coords,_ in
            if let coords = coords {
                self?.coordinates.append(coords)
            }
            group.leave()
        })
        group.enter()
        getCoordinateFrom(address: second, completion: { [weak self] coords,_ in
            if let coords = coords {
                self?.coordinates.append(coords)
            }
            group.leave()
        })
        group.notify(queue: .main) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                self.presenter?.buildPath(coords: self.coordinates)
                self.coordinates.removeAll()
            }
        }
    }
    
    private func getCoordinateFrom(address: String, completion:
                                   @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?)
                                   -> () ) {
        DispatchQueue.global(qos: .background).async {
            CLGeocoder().geocodeAddressString(address)
            { completion($0?.first?.location?.coordinate, $1) }
        }
    }
}
