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
        
        if(Deck.count()==0){
            Deck.addCard(Card(question:"What is my favourite color?",
                answer:"Blue",
                image:"sonic.png")
            );
            Deck.addCard(Card(question:"What is my name?",
                answer:"Quinton Black",
                image:"quinton-black.jpg")
            );
            Deck.addCard(Card(question:"What is my favourite Series?",
                answer:"Malazan Book of the Fallen.",
                image:"stevenerikson.jpg")
            );
            
            Deck.addCard(Card(question: "What gets wetter the more it dries?",
                answer:"A Towel.",
                image: "funny-wet-cats-36.jpg")
            );
            
            Deck.addCard(Card(question: "Whos that Pokemon?",
                answer:"Pikachu.",
                image: "whos-that-pokemon-pikachu.png")
            );
        }


        
        
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

