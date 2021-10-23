//
//  ViewController.swift
//  rokhanPW4
//
//  Created by Roman on 21.10.2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionLable: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var notes: [Note] = [] {
        didSet {
            collectionLable.isHidden = true
            collectionView.insertItems(at: [IndexPath(row: notes.count - 1, section: 0)])
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.contentInset = UIEdgeInsets(top: 15, left: 30, bottom: 15, right: 30)
        collectionView.collectionViewLayout = AutoInvalidatingLayout()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNote))
        navigationController?.navigationBar.tintColor = .red
    }
    
    @objc
    func createNote() {
        guard let viewController = storyboard?.instantiateViewController(identifier: "NoteViewController") as? NoteViewController else {
            return
        }
        viewController.outputViewController = self
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension ViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notes.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension ViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoteCell", for: indexPath) as! NoteCell
        cell.titleLable.text = notes[indexPath.row].title
        cell.descriptionLable.text = notes[indexPath.row].description
        cell.setup()
        cell.setShadow()
        return cell
    }
}

