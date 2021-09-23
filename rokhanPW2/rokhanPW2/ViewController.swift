//
//  ViewController.swift
//  rokhanPW2
//
//  Created by Roman on 22.09.2021.
//

import UIKit
import CoreLocation
import AVFoundation

class ViewController: UIViewController {

    // Обьект тектового поля по среди экранаю
    let locationTextView = UITextView()
    
    // Обьект кастомного settingsViews
    let settingsView = CustomSettingView()
    
    // Обьект нового экрана (который появляется при нажатии кнопки несколько раз)
    let newScreen = SettingsViewController()
    
    // Обьект плэера звуковю
    private var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Настройка
        setupLocationTextView()
        setupSettingsView()
        setupSettingsButton()
        
        // Установка зависимостей между двумя экранами
        // В сущности, это сделано для того, чтобы слайдеры
        // и свитчеры всегда были одинаковыми на разынх экранах
        newScreen.SettingsView.views = [view, newScreen.view]
        newScreen.SettingsView.CoordText = locationTextView
        newScreen.viewController = self
        
        view.backgroundColor = .cyan
        
        
        // Установка связи с звуковым файлом и подготовка к проигрываниюю
        do {
            guard let soundFileURL = Bundle.main.url(
                    forResource: "among",
                    withExtension: "mp3")
            else {
                return
            }
            audioPlayer = try AVAudioPlayer(contentsOf: soundFileURL)
            audioPlayer.prepareToPlay()
        }
        catch {
            print("Загрузить аудио не получилось :(")
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // Метод настройки кнопки (пункт 1 тз)
    private func setupSettingsButton() {
        let settingsButton = UIButton(type: .system)
        settingsButton.setTitle("settings", for: .normal)
        settingsButton.setImage(UIImage(named: "setting-2"), for: .normal)
        view.addSubview(settingsButton)
        settingsButton.addTarget(self, action: #selector(settingsButtonPressed), for: .touchUpInside)
        
        
        // Решил добавить себе удобные команды для констренов (файл UIView_Pin)
        settingsButton.PinRight(to: view, 15)
        settingsButton.PinTop(to: view, 15)
        settingsButton.PinHeight(30)
        settingsButton.PinWidth(settingsButton.heightAnchor)
    }
    
    // Событие нажатия на кнопку (пункты тз: 2,4,5)
    private var buttonCount = 0
    @objc private func settingsButtonPressed() {
        // Так как придумать, как привязать один и тот же кастомный обьект к 2-м экранам я не придумал,
        // Пришлось пользоваться таким способом передачи данныз между экранами.
        CustomSettingView.ParametrsCopy(to: newScreen.SettingsView, from: settingsView)
        
        // Открытие меню настроек.
        // В SceneDelegate был добавлен navigator controller (пункт 9 тз)
        switch buttonCount {
        case 0, 1:
            if (self.settingsView.alpha == 0) {
                audioPlayer.play()
            }
            UIView.animate(withDuration: 0.2, animations: {
                self.settingsView.alpha = 1 - self.settingsView.alpha
            })
        case 2:
            audioPlayer.play()
            navigationController?.pushViewController(
                newScreen,
                animated: true
            )
        case 3:
            audioPlayer.play()
            present(newScreen, animated: true, completion: nil)
        default:
            buttonCount = -1
        }
        buttonCount += 1
    }
    
    // Настройки текстового поля главного экрана.
    private func setupLocationTextView() {
        view.addSubview(locationTextView)
        locationTextView.backgroundColor = .white
        locationTextView.layer.cornerRadius = 20
        locationTextView.PinTop(to: view, 60)
        locationTextView.PinXCenter(to: view)
        locationTextView.PinHeight(300)
        locationTextView.PinLeft(to: view, 15)
        locationTextView.isUserInteractionEnabled = false
    }
    
    // Настройка кастомного settingsView
    private func setupSettingsView() {
        settingsView.CoordText = locationTextView
        settingsView.views = [view, newScreen.view]
        view.addSubview(settingsView)
        settingsView.backgroundColor = UIColor(white: 1, alpha: 0.8)
        settingsView.alpha = 0
        settingsView.PinTop(to: view, 10)
        settingsView.PinRight(to: view, 10)
        settingsView.PinHeight(300)
        settingsView.PinWidth(settingsView.heightAnchor, 2/3)
        settingsView.layer.cornerRadius = 15
    }

}
