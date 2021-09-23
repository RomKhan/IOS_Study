//
//  CustomSlider.swift
//  rokhanPW2
//
//  Created by Roman on 23.09.2021.
//

import UIKit

// Класс кастомного слайдера (пункт 8 тз)
class CustomSlider : UIView {

    // Решил сохранять составляющие.
    private let label = UILabel()
    private let slider = UISlider()
    
    // Свойства для получения составляющих кастомного ползунка.
    public var Label: UILabel {
        get {
            return label
        }
    }
    public var Slider: UISlider {
        get {
            return slider
        }
    }
    
    // Конструктор класса
    // Здесь и происходит создание всех необходимых компонентов кастомного сладера и их настройка.
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        label.PinTop(to: self, 5)
        label.PinLeft(to: leadingAnchor)
        label.PinWidth(50)
        
        slider.minimumValue = 0
        slider.maximumValue = 1
        addSubview(slider)
        slider.PinTop(to: self, 5)
        slider.PinHeight(20)
        slider.PinLeft(to: label, 50)
        slider.PinRight(to: self.trailingAnchor)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Метод, позволяющий добавлять событие кастомному слайдеру.
    public func addTarget(_ target: Any?, _ action: Selector, for type: UIControl.Event) {
        slider.addTarget(target, action: action, for: type)
    }
}
