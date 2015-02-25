//
//  StoryViewController.swift
//  blac_a05
//
//  Created by Quinton Black on 2015-02-24.
//  Copyright (c) 2015 Quinton Black. All rights reserved.
//

import UIKit

class StoryViewController: UIViewController {

   
    @IBOutlet weak var navbar: UINavigationItem!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var articleContent: UILabel!
    
    var story : Story = Story();
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        navbar.title = story.title;
        articleContent.text = story.content;
        let url = NSURL(string: story.imageUrl);
        let data = NSData(contentsOfURL: url!);
        var image = UIImage(data: data!);
        imageButton.setBackgroundImage(image,forState:UIControlState.Normal);
        imageButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit;

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        let articleWebViewController = segue.destinationViewController as ArticleWebViewController;
        articleWebViewController.url = self.story.url;
        
    }

}
