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
    
    /// Массив моделей.
    var notes: [Note] = [] {
        didSet {
            collectionLable.isHidden = true
            collectionView.insertItems(at: [IndexPath(row: notes.count - 1, section: 0)])
        }
    }
    
    /// Контекст текущей модели.
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
        
        /// Установка кнопки добавления заметки и ее настройка.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNote))
        navigationController?.navigationBar.tintColor = .red
        self.loadData()
    }
    
    /// Сохраниение контеста для кордаты.
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
    
    /// Загрузка данных из кордаты.
    func loadData() {
        if let notes = try? context.fetch(Note.fetchRequest()) as [Note] {
            self.notes = notes.sorted(by: {$0.creationDate.compare($1.creationDate) == .orderedDescending})
        } else {
            self.notes = []
        }
    }
    
    /// Перезагрузка одной ячейки (используется для отрисовки статуса).
    func reloadCell(at row: Int) {
        if row == -1 {return}
        collectionView.reloadItems(at: [IndexPath(row: row, section: 0)])
    }
    
    /// Запуск окна с добавлением заметки и ее добавление в коллекшн.
    @objc
    func createNote() {
        guard let viewController = storyboard?.instantiateViewController(identifier: "NoteViewController") as? NoteViewController else {
            return
        }
        viewController.outputViewController = self
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    /// Метод запускает экран, который полностью показывает описание заметки (также позволяет менять статус).
    func showFullDescription(index: Int) {
        guard let viewController = storyboard?.instantiateViewController(identifier: "NoteViewController") as? NoteViewController else {
            return
        }
        viewController.model = notes[index]
        viewController.outputViewController = self
        viewController.id = index
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
        cell.setStatusColor(colorType: Int(notes[indexPath.row].status))
        cell.setup(row: indexPath.row, showCellAction: showFullDescription)
        return cell
    }
}

