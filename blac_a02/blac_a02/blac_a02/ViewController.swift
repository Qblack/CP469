//
//  ViewController.swift
//  blac_a02
//
//  Created by Student on 2015-01-26.
//  Copyright (c) 2015 blac2410. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!;
    @IBOutlet weak var questionText: UILabel!;
    @IBOutlet weak var answerText: UILabel!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var deck = Deck() // you must instantiate an instance of a structure before using it
        if let i = NSUserDefaults.standardUserDefaults().integerForKey("currentIndex") as Int? {
            println("viewDidLoad, current index is \(i)") // see what you get in the console area
            Deck.setCardIndex(i) // see the correct card on the deck
            // initialize the question, answer and image for the scene
            
            var currentCard = Deck.getCard();
        
            
            self.displayCard(currentCard);
            
            
            
        }
    }

  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showQuestion(sender: UIButton) {
        var card = Deck.getNextCard();
        displayCard(card);
    }
    
    
    @IBAction func showAnswer(sender: UIButton) {
        var currentCard = Deck.getCard();
        answerText.text = currentCard.answer;
    }
    
    func displayCard(card: Card){
        questionText.text = card.question;
        answerText.text = "???";
        var nextImage = UIImage(named: card.image);
        image.image = nextImage; // set UIImageView to UIImage
    }

}

