//
//  PickerViewController.swift
//  blac_a03
//
//  Created by Student on 2015-02-02.
//  Copyright (c) 2015 blac2410. All rights reserved.
//

import UIKit;

class PickerViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate  {
    
    
    @IBOutlet weak var m_image: UIImageView!
    @IBOutlet weak var m_picker: UIPickerView!
    var colors = ["Red","Yellow","Green","Blue"];
 
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        
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

        

        
        m_picker.delegate = self;
        m_picker.dataSource = self;

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Deck.count();
    }
   	
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        var card : Card = Deck.getCard(row);
        var image = UIImage(named: card.image);
        m_image.image = image; // set UIImageView to UIImage
        return card.question;
    }
    
    @IBAction func showAnswer(sender: UIButton) {
        var row : Int = m_picker.selectedRowInComponent(0);
        var card: Card = Deck.getCard(row);
        var alert = UIAlertController(title: "Answer",message:card.answer, preferredStyle:.Alert);
        var action = UIAlertAction(title: "Done", style: .Default, handler: nil);
        alert.addAction(action);
        presentViewController(alert,animated:true,completion:nil);
    }

}