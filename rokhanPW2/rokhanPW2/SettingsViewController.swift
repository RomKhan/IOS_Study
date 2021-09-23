//
//  SettingsViewController.swift
//  rokhanPW2
//
//  Created by Roman on 23.09.2021.
//

import UIKit
import CoreLocation

// Клас экрана настроек
// В связи с тем, что был создан кастомный settingsView,
// Здесь отсались только методы настройки этого view и кнопки закрытия экрана.
// Пункты тз: 4,5.
final class SettingsViewController: UIViewController {
    
    // Обьект основного контроллераю.
    var viewController: ViewController!
    
    // Обьект кастомного settingsView.
    private var settingsView = CustomSettingView()
    
    // Обертка для кастомного settingsView.
    private let setView = UIView()
    
    // Свойсвой, позволяющее получить settingsView.
    // Используется для обмена информацией между экранами.
    public var SettingsView: CustomSettingView {
        get {
            return settingsView
        }
        set(value) {
            settingsView = value
            setupSettingsView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSettingsView()
        setupCloseButton()
        view.backgroundColor = .blue
    }
    
    // Настройка SettingsView и обертки.
    private func setupSettingsView() {
        view.addSubview(setView)
        setView.backgroundColor = .white
        setView.PinRight(to: view, 20)
        setView.PinTop(to: view, 20)
        setView.PinLeft(to: view, 20)
        setView.PinBotton(to: view, 20)
        setView.layer.cornerRadius = 15
        setView.addSubview(settingsView)
        settingsView.PinTop(to: setView)
        settingsView.PinRight(to: setView)
        settingsView.PinLeft(to: setView)
    }
    
    // Настройка кнопки закрытия экрана.
    private func setupCloseButton() {
        let button = UIButton(type: .close)
        settingsView.addSubview(button)
        button.PinRight(to: settingsView, 10)
        button.PinTop(to: settingsView, 10)
        button.PinHeight(30)
        button.PinWidth(button.heightAnchor)
        button.addTarget(self, action: #selector(closeScreen),
                         for: .touchUpInside)
        
    }
    
    @objc
    private func closeScreen() {
        dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
        // Здесб текущее окно сообщает информацию о свитче и слайдерах главному окну.
        CustomSettingView.ParametrsCopy(to: viewController.settingsView, from: settingsView)
    }
}
