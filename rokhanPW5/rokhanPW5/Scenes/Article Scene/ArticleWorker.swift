//
//  NewsTableWorker.swift
//  rokhanPW5
//
//  Created by Roman on 09.11.2021.
//

import Foundation

protocol ArticleWorkerLogic {
    func fetchNews(_ rubric: Int, _ pageIndex: Int, success: @escaping(ArticlePage) -> (), fail: @escaping() -> ())
}

class ArticleWorker : ArticleWorkerLogic {
    var interactor: (ArticleBuisnessLogic & ArticleDataStore)?
    
    /// Текущий url страницы.
    private func getURL(_ rubric: Int, _ pageIndex: Int) -> URL? {
        URL(string: "https://news.myseldon.com/api/Section?rubricId=\(rubric)&pageSize=8&pageIndex=\(pageIndex)")
    }
    
    /// Подгрузка данных с сервера.
    func fetchNews(_ rubric: Int, _ pageIndex: Int,
                   success: @escaping(ArticlePage) -> (),
                   fail: @escaping() -> ()) {
        guard let url = getURL(rubric, pageIndex) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                fail()
                return
            }
            if let data = data {
                let page = try? JSONDecoder().decode(ArticlePage.self, from: data)
                guard var articlePage = page else { fail(); return }
                articlePage.passTheRequestId()
                success(articlePage)
            }
        }.resume()
    }
}
