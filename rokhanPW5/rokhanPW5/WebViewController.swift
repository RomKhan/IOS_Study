//
//  WebViewController.swift
//  rokhanPW5
//
//  Created by Roman on 11.11.2021.
//

import UIKit
import WebKit

protocol WebDisplayLogic {
    func loadWebView(url: URL?)
}
class WebViewController: UIViewController, WebDisplayLogic {
    var webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        view.backgroundColor = .black
    }
    
    func loadWebView(url: URL?) {
        guard let urlNotNil = url else { return }
        webView.load(URLRequest(url: urlNotNil))
    }
}
