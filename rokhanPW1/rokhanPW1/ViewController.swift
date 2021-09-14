//
//  ViewController.swift
//  rokhanPW1
//
//  Created by Roman on 14.09.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var views: [UIView]!
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.layer.cornerRadius = 10
        
        super.view.bringSubviewToFront(button)
    }

    var countOfVisible = 0
    @IBAction func changeColorButtonPressed(_ sender: Any) {

        
        for view in views {
            view.frame = CGRect(x: CGFloat(arc4random_uniform(UInt32(self.view.frame.width))), y: CGFloat(arc4random_uniform(UInt32(self.view.frame.height))), width: CGFloat(Int.random(in: 10...200)), height: CGFloat(Int.random(in: 10...200)))
            
            let random = Int.random(in: 0...1)
            if random == 0 && countOfVisible>6 && view.isHidden != true {
                view.isHidden = true
                countOfVisible -= 1
            }
            else if random == 1 && view.isHidden != false {
                view.isHidden = false
                countOfVisible += 1
            }
        }
        
        var set = Set<UIColor>()
        while set.count < views.count {
        set.insert(
        UIColor(
        red: .random(in: 0...1),
        green: .random(in: 0...1),
        blue: .random(in: 0...1),
        alpha: 1))}
        
        for view in views {
            view.layer.cornerRadius = 10
        view.backgroundColor = set.popFirst()
        }
    }
    
}

