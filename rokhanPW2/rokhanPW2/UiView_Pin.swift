//
//  UiView_Pin.swift
//  rokhanPW2
//
//  Created by Roman on 22.09.2021.
//

import UIKit

// Расширение UIView.
// Хоть я и писал этот файлик сам, тут ничего нового,
// Тут все то же самое, что было на лекции(и в файле, который скинули в вк).
extension UIView {
    
    enum Sides {
        case top
        case right
        case left
        case botton
    }
    
    func Pin(to someView: UIView, _ sides: [Sides: Double]) {
        translatesAutoresizingMaskIntoConstraints = false
        for side in sides {
            switch side.key {
                case .top:
                    PinTop(to: someView, side.value)
                case .right:
                    PinRight(to: someView, side.value)
                case .left:
                    PinLeft(to: someView, side.value)
                case .botton:
                    PinBotton(to: someView, side.value)
            }
        }
    }
    
    func PinTop(to view: UIView, _ const: Double = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: CGFloat(const)
        ).isActive = true
    }
    
    func PinLeft(to view: UIView, _ const: Double = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor,
            constant: CGFloat(const)
        ).isActive = true
    }
    
    func PinLeft(to view: NSLayoutXAxisAnchor) {
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(
            equalTo: view
        ).isActive = true
    }
    
    func PinRight(to view: UIView, _ const: Double = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor,
            constant: -CGFloat(const)
        ).isActive = true
    }
    
    func PinRight(to view: NSLayoutXAxisAnchor) {
        translatesAutoresizingMaskIntoConstraints = false
        trailingAnchor.constraint(
            equalTo: view
        ).isActive = true
    }
    
    func PinBotton(to view: UIView, _ const: Double = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: -CGFloat(const)
        ).isActive = true
    }
    
    func PinHeight(_ const: Double) {
        heightAnchor.constraint(
            equalToConstant: CGFloat(const)
        ).isActive = true
    }
    
    func PinWidth(_ const: Double) {
        widthAnchor.constraint(
            equalToConstant: CGFloat(const)
        ).isActive = true
    }
    
    func PinWidth(_ to: NSLayoutDimension) {
        widthAnchor.constraint(equalTo: to).isActive = true
    }
    
    func PinWidth(_ to: NSLayoutDimension, _ const: Double) {
        widthAnchor.constraint(
            equalTo: to,
            multiplier: CGFloat(const)
        ).isActive = true
    }
    
    func PinXCenter(to view: UIView) {
        centerXAnchor.constraint(
            equalTo: view.centerXAnchor
        ).isActive = true
    }
    
    func PinYCenter(to view: UIView) {
        centerYAnchor.constraint(
            equalTo: view.centerYAnchor
        ).isActive = true
    }
}
