//
//  NewsViewController.swift
//  rokhanPW5
//
//  Created by Roman on 09.11.2021.
//

import UIKit

protocol ArticleDisplayLogic {
    func updateCells(articles: [ArticleViewModel])
    func pushControler(vc: UIViewController)
}

class ArcticleViewController: UIViewController, ArticleDisplayLogic {
    var interactor: (ArticleBuisnessLogic & ArticleDataStore)?
    var router: (ArticleRouterLogic & ArticleDataPassing)?
    var tableView = UITableView()
    var activityIndicator = UIActivityIndicatorView()
    var articleViewModels: [ArticleViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.backgroundColor = .black
        tableView.register(ArticleCell.self, forCellReuseIdentifier: "ArticleCell")
        tableView.showsVerticalScrollIndicator = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 300
        tableView.backgroundColor = UIColor(white: 1, alpha: 0)
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.tintColor = .systemRed
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        activityIndicator.color = .systemRed
        activityIndicator.hidesWhenStopped = true
        tableView.tableFooterView = activityIndicator
        interactor?.loadFreshNews()
    }
    
    @objc func handleRefreshControl() {
        DispatchQueue.global().async {
            sleep(1)
            DispatchQueue.main.async {
                self.articleViewModels.removeAll()
                self.interactor?.loadFreshNews()
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    func updateCells(articles: [ArticleViewModel]) {
        sleep(1)
        DispatchQueue.main.async {
            let list = (0..<articles.count).compactMap { [weak self] i in
                return IndexPath(row: (self?.articleViewModels.count ?? 1) + i, section: 0)
            }
            self.articleViewModels += articles
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: list, with: .automatic)
            self.tableView.endUpdates()
            self.activityIndicator.stopAnimating()
        }
    }
    
    func pushControler(vc: UIViewController) {
        navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func hey() {
        print("he")
    }
}

extension ArcticleViewController: UITableViewDelegate {
    /// Количетсво секций.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router?.routeToWeb(url: articleViewModels[indexPath.row].articleURL)
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive,
                                        title: "Share") { [weak self] (action, view, completionHandler) in
                                            self?.router?.routeToShareMenu(
                                                url: self?.articleViewModels[indexPath.row].articleURL
                                            )
                                            completionHandler(true)
                                        }
        action.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [action])
    }
}

extension ArcticleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as? ArticleCell
        if (indexPath.row == articleViewModels.count - 1) {
            self.activityIndicator.startAnimating()
            self.interactor?.loadMoreNews()
        }
        if (cell?.ArticleViewModel?.imageURL != articleViewModels[indexPath.row].imageURL ||
            cell?.ArticleViewModel?.title != articleViewModels[indexPath.row].title ||
            cell?.ArticleViewModel?.description != articleViewModels[indexPath.row].description) {
            cell?.ArticleViewModel = articleViewModels[indexPath.row]
        }
        return cell ?? UITableViewCell()
    }
}
