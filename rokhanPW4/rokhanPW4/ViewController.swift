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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = AutoInvalidatingLayout()
    }
    
    func updateConstrain () {
        
    }
}

extension ViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension ViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoteCell", for: indexPath) as! NoteCell
        cell.titleLable.text = "Yeah"
        cell.descriptionLable.text = "That's greate"
        cell.setup()
       return cell
    }
}

