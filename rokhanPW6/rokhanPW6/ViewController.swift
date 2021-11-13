//
//  ViewController.swift
//  rokhanPW6
//
//  Created by Roman on 13.11.2021.
//

import UIKit

class ViewController: UIViewController {
    var frameworkButton = UIButton()
    var packageButton = UIButton()
    var podButton = UIButton()
    var charthageButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupButtons()
        frameworkButton.addTarget(self, action: #selector(frameworkButtonClick(sender:)), for: .touchDown)
        packageButton.addTarget(self, action: #selector(packageButtonClick(sender:)), for: .touchDown)
        podButton.addTarget(self, action: #selector(podButtonClick(sender:)), for: .touchDown)
        charthageButton.addTarget(self, action: #selector(charthageClick(sender:)), for: .touchDown)
    }
    
    func setupButtons() {
        view.addSubview(frameworkButton)
        view.addSubview(packageButton)
        view.addSubview(podButton)
        view.addSubview(charthageButton)
        frameworkButton.setTitle("Log (framework)", for: .normal)
        packageButton.setTitle("Log (swift package)", for: .normal)
        podButton.setTitle("Log (pod)", for: .normal)
        charthageButton.setTitle("Log (charthage)", for: .normal)
        frameworkButton.setTitleColor(UIColor.systemBlue, for: .normal)
        packageButton.setTitleColor(UIColor.systemBlue, for: .normal)
        podButton.setTitleColor(UIColor.systemBlue, for: .normal)
        charthageButton.setTitleColor(UIColor.systemBlue, for: .normal)
        frameworkButton.translatesAutoresizingMaskIntoConstraints = false
        frameworkButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -60).isActive = true
        frameworkButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        packageButton.translatesAutoresizingMaskIntoConstraints = false
        packageButton.topAnchor.constraint(equalTo: frameworkButton.bottomAnchor).isActive = true
        packageButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        podButton.translatesAutoresizingMaskIntoConstraints = false
        podButton.topAnchor.constraint(equalTo: packageButton.bottomAnchor).isActive = true
        podButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        charthageButton.translatesAutoresizingMaskIntoConstraints = false
        charthageButton.topAnchor.constraint(equalTo: podButton.bottomAnchor).isActive = true
        charthageButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    }
    
    @objc func frameworkButtonClick(sender: Any) {
        
    }
    
    @objc func packageButtonClick(sender: Any) {
        
    }
    
    @objc func podButtonClick(sender: Any) {
        
    }
    
    @objc func charthageClick(sender: Any) {
        
    }
}

