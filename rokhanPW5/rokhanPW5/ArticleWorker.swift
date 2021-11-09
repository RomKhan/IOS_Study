//
//  NewsTableWorker.swift
//  rokhanPW5
//
//  Created by Roman on 09.11.2021.
//

import Foundation

protocol ArticleWorkerLogic {
    
}

class ArticleWorker : ArticleWorkerLogic {
    var interactor: (ArticleBuisnessLogic & ArticleDataStore)?
}
