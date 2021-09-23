//
//  CustomSettingView.swift
//  rokhanPW2
//
//  Created by Roman on 23.09.2021.
//

import UIKit

// Класс кастомного переключателя.(пункты 7, 6 тз)
class CustomSettingView: UIStackView {
    
    // Слайдеры изменения цвета заднего фона.
    private var sliders = [CustomSlider(), CustomSlider(), CustomSlider()]
    private let colors = ["Red", "Green", "Blue"]
    
    // Текстовое поле, в которе будет происходить вывод координат.
    private var coordText = UITextView()
    
    // Переключатель
    var locationToggle = LocationToggle()
    
    // Все окна, задний цвет которых нужно сменить.
    var views: [UIView]! = nil
    
    public var Sliders: [CustomSlider] {
        get {
            return sliders
        }
        set(value) {
            sliders = value
        }
    }
    
    public var CoordText: UITextView {
        get {
            return coordText
        }
        set(value) {
            coordText = value
            locationToggle.CoordText = coordText
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLocationManager()
        setupLocationToggle()
        setupSliders()
        
        axis = .vertical
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Настройка переключателя (пункт 3 тз)
    private func setupLocationToggle() {
        self.addArrangedSubview(locationToggle)
        
        locationToggle.PinTop(to: self, 50)
        locationToggle.PinRight(to: self, 10)
    }
    
    // Добавление текстового поля к меню настроек.
    private func setupLocationManager() {
        let locationLabel = UILabel()
        self.addArrangedSubview(locationLabel)
        locationLabel.text = "Location"
        locationLabel.textColor = .black
        locationLabel.PinTop(to: self, 55)
        locationLabel.PinLeft(to: self, 10)
        locationLabel.PinRight(to: self, -10)
    }
    
    // Добавление и настройка кастомных слайдоеров.
    private func setupSliders() {
        for i in 0..<sliders.count {
            let view = CustomSlider()
            self.addArrangedSubview(view)
            view.PinLeft(to: self, 15)
            view.PinRight(to: self, 15)
            view.PinHeight(40)
            view.Label.text = colors[i]
            view.Label.textColor = .black
            view.addTarget(self, #selector(sliderChangedValue), for: .valueChanged)
            sliders[i] = view
        }
    }
    
    // Событие слайдеров.
    // Здесь задний фон всех сохраненных экранов красится.
    @objc private func sliderChangedValue(_ sender: UISlider) {
        for i in 0..<views.count {
            let red: CGFloat = CGFloat(sliders[0].Slider.value)
            let green: CGFloat = CGFloat(sliders[1].Slider.value)
            let blue: CGFloat = CGFloat(sliders[2].Slider.value)
            views[i].backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
        }
    }
    
    // Статический метод копирвоания данных из одного кастомного меню настроек в другой.
    // Создано для обмена информацией между экранами (чтобы настройки на разных экранах были одинаковые).
    public static func ParametrsCopy(to: CustomSettingView, from: CustomSettingView) {
        to.locationToggle.isOn = from.locationToggle.isOn
        for i in 0...2 {
            to.Sliders[i].Slider.value = from.Sliders[i].Slider.value
        }
    }
    
}
