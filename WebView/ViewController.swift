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
    
    private lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let wkWebView = WKWebView(frame: .zero, configuration: webConfiguration)
        
        wkWebView.isOpaque = false
        wkWebView.backgroundColor = .white
        wkWebView.allowsLinkPreview = false
        wkWebView.allowsBackForwardNavigationGestures = true
        wkWebView.translatesAutoresizingMaskIntoConstraints = false
        
        return wkWebView
    }()
    
    private lazy var progressView: UIProgressView = {
        let uiProgressView = UIProgressView()
        uiProgressView.progress = 0.0
        uiProgressView.progressTintColor = .darkGray
        uiProgressView.trackTintColor = .white
        uiProgressView.translatesAutoresizingMaskIntoConstraints = false
        
        return uiProgressView
    }()
    
    private lazy var refreshControl:UIRefreshControl = {
        let uiRefreshControl = UIRefreshControl()
        uiRefreshControl.addTarget(self, action: #selector(refreshWebView), for: .valueChanged)
        
        return uiRefreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupPullToRefresh()
        
        loadWebView()
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        view.addSubview(webView)
        view.addSubview(progressView)
        
        if #available(iOS 11.0, *) {
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            webView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            
            progressView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        }
        
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        progressView.heightAnchor.constraint(equalToConstant: 3.0).isActive = true
        progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func loadWebView() {
        if let url = URL(string: website) {
            let request = URLRequest(url: url)
            
            webView.load(request)
            webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
        
        if (progressView.progress >= 1.0) {
            progressView.alpha = 0.0
        }else {
            progressView.alpha = 1.0
        }
    }
    
    private func setupPullToRefresh() {
        webView.scrollView.bounces = true
        webView.scrollView.addSubview(refreshControl)
    }
    
    @objc private func refreshWebView() {
        webView.reload()
        refreshControl.endRefreshing()
    }

}

