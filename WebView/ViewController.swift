//
//  ViewController.swift
//  WebView
//
//  Created by Hisman on 09/03/19.
//  Copyright © 2019 Hisman. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    private let website = "https://hisman.co"
    
    private let webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let wkWebView = WKWebView(frame: .zero, configuration: webConfiguration)
        
        wkWebView.isOpaque = false
        wkWebView.backgroundColor = .white
        wkWebView.allowsLinkPreview = false
        wkWebView.allowsBackForwardNavigationGestures = true
        wkWebView.translatesAutoresizingMaskIntoConstraints = false
        
        return wkWebView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(webView)
        
        setupLayout()
        loadWebView()
    }
    
    private func setupLayout() {
        if #available(iOS 11.0, *) {
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            webView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
        
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func loadWebView() {
        let url = URL(string: website)
        
        if let url = url {
            let request = URLRequest(url: url)
            
            webView.load(request)
        }
    }

}

