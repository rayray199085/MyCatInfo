//
//  SCBreedWikiController.swift
//  MyCatInfo
//
//  Created by Stephen Cao on 6/8/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//
import WebKit
import SVProgressHUD

class SCBreedWikiController: UIViewController {
    private var webView: WKWebView!
    var wikiUrl: String?{
        didSet{
            loadWebView()
        }
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.scrollView.bounces = false
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.isOpaque = false
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
//        loadWebView()
    }
}
private extension SCBreedWikiController{
    func setupUI(){
        //        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : HelperCommonValues.SCNaviBarTintColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0)]
    }
    func loadWebView(){
        guard let urlString = wikiUrl,
              let url = URL(string: urlString) else{
            return
        }
        webView.load(URLRequest(url: url))
    }
}
extension SCBreedWikiController: WKNavigationDelegate{
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SVProgressHUD.show()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
}
