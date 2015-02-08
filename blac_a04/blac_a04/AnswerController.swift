//
//  AnswerController.swift
//  blac_a04
//
//  Created by Student on 2015-02-07.
//  Copyright (c) 2015 blac2410. All rights reserved.
//

import Foundation;
import UIKit;

class AnswerController : UIViewController {


    @IBOutlet weak var image_button: UIButton!
    
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var answer: UILabel!
    var index: Int = 0;
    var m_url : String = "";
    
    	
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        var card: Card = Deck.getCard(index);
        displayCard(card);
        m_url = card.url;
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayCard(card: Card){
        question.text = card.question;
        answer.text = card.answer;
        
        
        //Using the image on a button to make the link
        var nextImage = UIImage(named: card.image);
        image_button.setImage( nextImage, forState: UIControlState.Normal	);
        image_button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Fill;
        image_button.contentVerticalAlignment = UIControlContentVerticalAlignment.Fill;
        image_button.imageView?.contentMode = UIViewContentMode.ScaleAspectFit;
       
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier=="showWebsite"{
            var webView = segue.destinationViewController as WebsiteViewController;
            webView.url = m_url;
        }
    }

    
}