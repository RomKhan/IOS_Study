//
//  TableViewController.swift
//  rokhanPW3
//
//  Created by Roman on 05.10.2021.
//

import UIKit

class TableViewController: UIViewController {
    private var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        setupTableView()
    }
    
    private func setupTableView() {
        let table = UITableView()
        view.addSubview(table)
        
        table.translatesAutoresizingMaskIntoConstraints = false
        table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        table.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        table.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        table.backgroundColor = .black
        
        self.table = table
    }
}
