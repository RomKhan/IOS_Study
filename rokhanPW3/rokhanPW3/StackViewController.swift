//
//  StackViewController.swift
//  rokhanPW3
//
//  Created by Roman on 05.10.2021.
//

import UIKit

class StackViewController: UIViewController {
    let stackView = UIStackView()
    
    private var collection: UICollectionView?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        setupStackView()
    }
    
    private func setupStackView() {
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 5
        
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        addAlarmsToStack()
    }
    
    private func addAlarmsToStack() {
        for _ in 0...20 {
            let alarm = AlarmView(19, 20, true)
            stackView.addArrangedSubview(alarm)
        }
    }

}
