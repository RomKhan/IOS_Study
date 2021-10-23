//
//  NoteViewController.swift
//  rokhanPW4
//
//  Created by Roman on 23.10.2021.
//

import UIKit

class NoteViewController : UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textField: UITextField!
    var outputViewController: ViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTabSaveNote(button:)))
    }
    
    @objc
    func didTabSaveNote(button: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
