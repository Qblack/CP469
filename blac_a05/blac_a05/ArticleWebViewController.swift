//
//  ArticleWebViewController.swift
//  blac_a05
//
//  Created by Quinton Black on 2015-02-24.
//  Copyright (c) 2015 Quinton Black. All rights reserved.
//

import UIKit

class ArticleWebViewController: UIViewController {

    @IBOutlet weak var navbar: UINavigationItem!
    @IBOutlet weak var webView: UIWebView!
    
    var url = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ns_url = NSURL(string: url)!;
        let request = NSURLRequest(URL: ns_url);
        webView.loadRequest(request);
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
