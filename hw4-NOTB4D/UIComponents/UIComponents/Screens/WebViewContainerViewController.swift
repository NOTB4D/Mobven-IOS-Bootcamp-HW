//
//  WebViewContainerViewController.swift
//  UIComponents
//
//  Created by Semih Emre ÜNLÜ on 9.01.2022.
//

import UIKit
import WebKit

class WebViewContainerViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureWebView()
        configureActivityIndicator()
    }



    func configureWebView() {
      /* guard let url = URL(string: urlString) else { return }
        _ = URLRequest(url: url)*/

        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = false

        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
//        webView.configuration = configuration
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.addObserver(self,
                            forKeyPath: #keyPath(WKWebView.isLoading),
                            options: .new,
                            context: nil)
        webView.loadHTMLString(urlString, baseURL: nil)
    }

    func configureActivityIndicator() {
        activityIndicator.style = .large
        activityIndicator.color = .red
        activityIndicator.hidesWhenStopped = true
    }
    
    

    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {

        if keyPath == "loading" {
            webView.isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        }

    }

    @IBAction func reloadButtonTapped(_ sender: UIBarButtonItem) {
        webView.reload()
        
    }
    @IBAction func goBackButtonTapped(_ sender: UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    @IBAction func goForwardButtonTapped(_ sender: UIBarButtonItem){
        webView.goForward()
    }
    
    @IBAction func openWithSafariButtonTapped(_ sender: UIBarButtonItem){
        UIApplication.shared.open(webView.url!, options: [:], completionHandler: nil)
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        let css = "h1 {font-family: Lucida Console ; font-weight:Bold; color: red;} p{color: green;background-color: lightgrey;width: auto; }"
        
        let js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
        
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
    var urlString = """
            <!DOCTYPE html>
            <html>
            
            
            </style>
            <body>

            <h1>My First Heading</h1>
            <p>My first paragraph.</p>

            </body>
            </html>
            """
}

extension WebViewContainerViewController: WKNavigationDelegate {
   

}

extension WebViewContainerViewController: WKUIDelegate {

}


