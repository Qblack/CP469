//
//  WebsiteViewController.swift
//  blac_a04
//
//  Created by Student on 2015-02-08.
//  Copyright (c) 2015 blac2410. All rights reserved.
//

import UIKit;

class WebsiteViewController: UIViewController {

    var url: String = "";
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        configureView();
        
       
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func configureView(){
        let ns_url = NSURL(string: url)!;
        let request = NSURLRequest(URL: ns_url);
        webView.loadRequest(request);
        
        
    }
  
    
}
