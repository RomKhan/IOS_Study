//
//  LocationToggle.swift
//  rokhanPW2
//
//  Created by Roman on 23.09.2021.
//

import UIKit
import CoreLocation

// Класс кастомного переключатель (пункт 8 и 3 тз)
class LocationToggle : UISwitch, CLLocationManagerDelegate {
    
    // Менаджер локации.
    private let locationManager = CLLocationManager()
    
    // Текстовый обьект, в который будут печататься координаты.
    private var coordText = UITextView()
    
    // Свойство, позволяющее получить доступ к coordText
    // Используется для связи текстового обьект ViewController с обьектом данного класса.
    public var CoordText: UITextView {
        get {
            return coordText
        }
        set(value) {
            coordText = value
        }
    }
    
    // В конструкторе сразу добавляю соытие.
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self,
                         action: #selector(locationToggleSwitched),
                         for: .valueChanged)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Было решено событие перенести в этот класс, тк здесь оно выглядит более уместно.
    @objc
    func locationToggleSwitched(_ sender: UISwitch) {
        locationManager.requestWhenInUseAuthorization()
        if sender.isOn {
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
            } else {
                sender.setOn(false, animated: true)
            }
        } else {
            coordText.text = ""
            locationManager.stopUpdatingLocation()
        }
    }
    
    // Фрагмент этого кода в тз находился в расширении класса ViewController,
    // Но в связи с созданием кастомного переключателя, переехал сюда.
    // Тут координаты выводятся на текстовое поле основного экрана.
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let coord: CLLocationCoordinate2D =
                manager.location?.coordinate else { return }
        coordText.text = "Coordinates = \(coord.latitude) \(coord.longitude)"
    }
}
