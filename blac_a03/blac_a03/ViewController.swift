//
//  ViewController.swift
//  blac_a03
//
//  Created by Student on 2015-02-02.
//  Copyright (c) 2015 blac2410. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var m_image: UIImageView!
    @IBOutlet weak var m_question: UILabel!
    @IBOutlet weak var m_answer: UILabel!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Deck.addCard(Card(question:"In a marble hall white as milk lined with skin as soft as silk within a fountain crystal-clear. A golden apple doth appear. No doors there are to this stronghold, yet thieves break in to steal its gold.",
            answer:"An Egg.",
            image:"golden-apple-border.jpg")
        );
        Deck.addCard(Card(question:"What goes up a chimney down, but won't go down a chimney up?",
            answer:"An Umbrella",
            image:"FetchImage.ashx.jpeg")
        );
        Deck.addCard(Card(question:"What walks on four legs in the morning, two in the afternoon, and three in the evening?",
            answer:"A Person.",
            image:"oedipus.jpg")
        );
        
        Deck.addCard(Card(question: "What gets wetter the more it dries?",
            answer:"A Towel.",
            image: "funny-wet-cats-36.jpg")
        );
        
        Deck.addCard(Card(question: "What gets bigger the more you take out of it?",
            answer:"A Hole.",
            image: "61-bigger_dog_gets_the_bone.png")
        );
        
        Deck.addCard(Card(question: "Whos that Pokemon?",
            answer:"Pikachu.",
            image: "whos-that-pokemon-pikachu.png")
        );

        
        
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
        m_answer.text = currentCard.answer;
    }
        
    func displayCard(card: Card){
        m_question.text = card.question;
        m_answer.text = "???";
        var nextImage = UIImage(named: card.image);
        m_image.image = nextImage; // set UIImageView to UIImage
    }
        
}

