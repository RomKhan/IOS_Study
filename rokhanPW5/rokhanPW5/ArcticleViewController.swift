//
//  NewsViewController.swift
//  rokhanPW5
//
//  Created by Roman on 09.11.2021.
//

import UIKit

protocol ArticleDisplayLogic {
    
}

class ArcticleViewController: UIViewController, ArticleDisplayLogic {
    var interactor: (ArticleBuisnessLogic & ArticleDataStore)?
    var router: (ArticleRouterLogic & ArticleDataPassing)?
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.register(ArticleCell.self, forCellReuseIdentifier: "ArticleCell")
        tableView.showsVerticalScrollIndicator = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .red
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension ArcticleViewController: UITableViewDelegate {
    /// Количетсво секций.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension ArcticleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
