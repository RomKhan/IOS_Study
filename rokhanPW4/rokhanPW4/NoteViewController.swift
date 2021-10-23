//
//  NoteViewController.swift
//  rokhanPW4
//
//  Created by Roman on 23.10.2021.
//

import UIKit

class NoteViewController : UIViewController {
    private var selectedRow: Int32 = 1
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var statusSelector: UIPickerView!
    var outputViewController: ViewController!
    var model: Note?
    var id: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTabSaveNote(button:)))
        if (model != nil) {
            textField.isUserInteractionEnabled = false
            textView.isEditable = false
            textView.text = model?.descriptionText
            textField.text = model?.title
        }
        statusSelector.dataSource = self
        statusSelector.delegate = self
        statusSelector.selectRow(Int(model?.status ?? 1), inComponent: 0, animated: true)
    }
    
    @objc
    func didTabSaveNote(button: UIBarButtonItem) {
        if (model == nil) {
            let title = textField.text ?? ""
            let descriptionText = textView.text ?? ""
            if !title.isEmpty {
                let newNote = Note(context: outputViewController.context)
                newNote.title = title
                newNote.descriptionText = descriptionText as String
                newNote.creationDate = Date()
                newNote.status = selectedRow
                outputViewController.saveChanges()
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

extension NoteViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
}

extension NoteViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch row {
        case 0:
            return "done"
        case 1:
            return "new"
        case 2:
            return "waiting"
        default:
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
       {
        selectedRow = Int32(row)
        model?.status = Int32(row)
        outputViewController.saveChanges()
        outputViewController?.reloadCell(at: id ?? -1)
        }
}
