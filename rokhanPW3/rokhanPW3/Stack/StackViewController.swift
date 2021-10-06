//
//  StackViewController.swift
//  rokhanPW3
//
//  Created by Roman on 05.10.2021.
//

import UIKit

class StackViewController: UIViewController {
    let stackView = UIStackView()
    let scroll = UIScrollView()
    
    private var collection: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        setupScroll()
        setupStackView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scroll.contentSize = CGSize(
            width: self.view.frame.width,
            height: stackView.frame.height
        )
    }
    
    private func setupScroll() {
        scroll.alwaysBounceVertical = true
        view.addSubview(scroll)
        
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func setupStackView() {
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 5
        
        scroll.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
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
