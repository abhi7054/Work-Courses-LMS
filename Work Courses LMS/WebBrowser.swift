//
//  Profile.swift
//  Work Courses LMS
//
//  Created by Arpit on 10/2/20.
//  Copyright © 2020 Dev Abhi. All rights reserved.
//

import WebKit

protocol WebBrowserDataSource {
    func getURL (for b:WebBrowser, index:Int) -> URL?
}

class WebBrowser : UIViewController {
    
    var wbDataSource : WebBrowserDataSource?
    var index : Int = 0
    var url : URL!
    var path : String!
    @IBOutlet var webView: WKWebView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        
        self.updatePathAndLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        super.hidesBottomBarWhenPushed = true
    }
    
    func load(path:String) {
        guard let  url = URL(string: path) else {
            self.show("Error", "Invalid URL.", "Back") { (condition) in
                self.navigationController?.popViewController(animated: true)
            }
            return
        }
        load(url: url)
    }
    
    func load(url:URL) {
        self.activityIndicator.startAnimating()
        let request = URLRequest(url: url)
        self.webView.load(request)
    }
    
    //..
    @IBAction func nextButtonTouched(_ sender: UIBarButtonItem) {
        //mark get path
        self.index += 1
        self.updatePathAndLoad()
    }
    
    func updatePathAndLoad() {
        if let p = self.wbDataSource?.getURL(for: self, index: self.index) {
            self.load(url: p)
        }
    }
    
    @IBAction func refreshButtonTouched(_ sender: Any) {
        self.updatePathAndLoad()
    }
    
    //implement later
    @IBAction func previousButtonTouched(_ sender: Any) {}
    @IBAction func homeButtonTouched(_ sender: Any) {}
}

//MARK: Navigation
extension WebBrowser {
    
}


extension WebBrowser : WKUIDelegate {
    
}

extension WebBrowser : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
    }

    private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        self.activityIndicator.stopAnimating()
        print(error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didFinish  navigation: WKNavigation!) {
        self.activityIndicator.stopAnimating()
    }

    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        self.activityIndicator.stopAnimating()
        print("finish to load")
    }
}
