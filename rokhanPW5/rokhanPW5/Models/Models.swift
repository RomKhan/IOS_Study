//
//  Models.swift
//  rokhanPW5
//
//  Created by Roman on 09.11.2021.
//

import Foundation

/// Модель страницы со статьями.
/// Используется для парсинга данных с сервера.
struct ArticlePage: Decodable {
    var news: [ArticleModel]?
    var requestId: String?
    
    mutating func passTheRequestId() {
        for i in 0..<(news?.count ?? 0) {
            news?[i].requestId = requestId
        }
    }
}

/// Модель статьи.
struct ArticleModel: Decodable {
    var newsId: Int?
    var title: String?
    var announce: String?
    var img: ImageContainer?
    var requestId: String?
    var articleUrl: URL? {
        let requestId = requestId ?? ""
        let newsId = newsId ?? 0
        return URL(string: "https://news.myseldon.com/ru/news/index/\(newsId)?requestId=\(requestId)")
    }
}

struct ImageContainer: Decodable {
    var url: URL?
}

/// Модель графического предсталвения статьи.
struct ArticleViewModel {
    var title: String?
    var description: String?
    var imageURL: URL?
    var articleURL: URL?
}
