//
//  ViewController.swift
//  rokhanPW1
//
//  Created by Roman on 13.09.2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var view1: UIView!
    
    override funsc viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func changeColorButtonPressed(_ sender: Any) {
        view1.backgroundColor = UIColor(
        red: .random(in: 0...1),
        green: .random(in: 0...1),
        blue: .random(in: 0...1),
        alpha: 1
        )
    }
}

