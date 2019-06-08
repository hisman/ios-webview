//
//  ViewController.swift
//  WebView
//
//  Created by Hisman on 09/03/19.
//  Copyright © 2019 Hisman. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    private let website = "https://hisman.co"
    
    // MARK: - Views
    
    private lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let wkWebView = WKWebView(frame: .zero, configuration: webConfiguration)
        
        wkWebView.isOpaque = false
        wkWebView.backgroundColor = .white
        wkWebView.navigationDelegate = self
        wkWebView.scrollView.bounces = true
        wkWebView.allowsLinkPreview = false
        wkWebView.allowsBackForwardNavigationGestures = true
        wkWebView.translatesAutoresizingMaskIntoConstraints = false
        wkWebView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
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
    
    private lazy var refreshControl: UIRefreshControl = {
        let uiRefreshControl = UIRefreshControl()
        uiRefreshControl.addTarget(self, action: #selector(refreshWebView), for: .valueChanged)
        
        return uiRefreshControl
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var reloadBtn: UIButton = {
        let button = UIButton(type: .system)
        button.isHidden = true
        button.setTitle("Reload", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(refreshWebView), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        loadWebView()
    }
    
    // MARK: - Setup WebView
    
    private func setupLayout() {
        view.backgroundColor = .white
        view.addSubview(webView)
        view.addSubview(progressView)
        view.addSubview(errorLabel)
        view.addSubview(reloadBtn)
        
        webView.scrollView.addSubview(refreshControl)
        
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                errorLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                errorLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            ])
            
        } else {
            NSLayoutConstraint.activate([
                webView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
                webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                progressView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
                errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            ])
        }
        
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 3.0),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            reloadBtn.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 20),
            reloadBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    // MARK: - Actions
    
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
    
    private func loadWebView() {
        if let url = URL(string: website) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    @objc private func refreshWebView() {
        if webView.url == nil {
            loadWebView()
        }else {
            webView.reload()
        }
        
        refreshControl.endRefreshing()
    }
    
    // MARK: - WKNavigation Delegate
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        errorLabel.isHidden = true
        reloadBtn.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        if webView.url == nil {
            errorLabel.text = error.localizedDescription
            errorLabel.isHidden = false
            reloadBtn.isHidden = false
        }
    }

}

