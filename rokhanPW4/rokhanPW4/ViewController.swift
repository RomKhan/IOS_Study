//
//  ViewController.swift
//  rokhanPW4
//
//  Created by Roman on 21.10.2021.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    @IBOutlet weak var collectionLable: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var notes: [Note] = [] {
        didSet {
            collectionLable.isHidden = true
            collectionView.insertItems(at: [IndexPath(row: notes.count - 1, section: 0)])
        }
    }
    let context: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: "CoreDataNotes")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Container loading failed")
            }
        }
        return container.viewContext
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.contentInset = UIEdgeInsets(top: 15, left: 30, bottom: 15, right: 30)
        collectionView.collectionViewLayout = AutoInvalidatingLayout()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNote))
        navigationController?.navigationBar.tintColor = .red
        self.loadData()
    }
    
    func saveChanges() {
        if context.hasChanges {
            try? context.save()
        }
        if let notes = try? context.fetch(Note.fetchRequest()) as? [Note] {
            self.notes = notes
        } else {
            self.notes = []
        }
    }
    
    func loadData() {
        if let notes = try? context.fetch(Note.fetchRequest()) as [Note] {
            self.notes = notes.sorted(by: {$0.creationDate.compare($1.creationDate) == .orderedDescending})
        } else {
            self.notes = []
        }
    }
    
    @objc
    func createNote() {
        guard let viewController = storyboard?.instantiateViewController(identifier: "NoteViewController") as? NoteViewController else {
            return
        }
        viewController.outputViewController = self
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showFullDescription(index: Int) {
        guard let viewController = storyboard?.instantiateViewController(identifier: "NoteViewController") as? NoteViewController else {
            return
        }
        viewController.model = notes[index]
        present(viewController, animated: true, completion: nil)
    }
}

extension ViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notes.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let identifier = "\(indexPath.row)" as NSString
        return UIContextMenuConfiguration(identifier: identifier, previewProvider: .none) { _ in let deleteAction = UIAction(title: "Delete", image:
                                            UIImage(systemName: "trash"), attributes:
                                                UIMenuElement.Attributes.destructive) { value in
                self.context.delete(self.notes[indexPath.row])
                self.saveChanges()
            }
                                            
            return UIMenu(title: "", image: nil, children: [deleteAction])
        }
    }
}

extension ViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoteCell", for: indexPath) as! NoteCell
        cell.titleLable.text = notes[indexPath.row].title
        cell.descriptionLable.text = notes[indexPath.row].descriptionText
        cell.setup(row: indexPath.row, showCellAction: showFullDescription)
        return cell
    }
}

