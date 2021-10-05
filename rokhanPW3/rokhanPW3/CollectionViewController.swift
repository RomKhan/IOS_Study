//
//  CollectionViewController.swift
//  rokhanPW3
//
//  Created by Roman on 05.10.2021.
//

import UIKit

class CollectionViewController: UIViewController {
    private var collection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let layoutFlow = UICollectionViewFlowLayout()
        layoutFlow.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layoutFlow.itemSize = CGSize(width: 60, height: 60)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layoutFlow)
        view.addSubview(collection)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collection.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collection.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collection.backgroundColor = .white
        self.collection = collection
    }
}
