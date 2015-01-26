//
//  Deck.swift
//  blac_a02
//
//  Created by Student on 2015-01-26.
//  Copyright (c) 2015 blac2410. All rights reserved.
//


import Foundation

struct Deck{
    static var m_deck: [Card] = []; // a deck is an array of cards
    
    static var current:Int = 0 // the current card on the deck (to be shown in the scene)
    
    init(){
        Deck.m_deck.append(Card(question:"In a marble hall white as milk lined with skin as soft as silk within a fountain crystal-clear. A golden apple doth appear. No doors there are to this stronghold, yet thieves break in to steal its gold.",answer:"An Egg.",image:"golden-apple-border.jpg")
        );
        Deck.m_deck.append(Card(question:"What goes up a chimney down, but won't go down a chimney up?",
            answer:"An Umbrella",
            image:"FetchImage.ashx.jpeg")
        );
        Deck.m_deck.append(Card(question:"What walks on four legs in the morning, two in the afternoon, and three in the evening?",
            answer:"A Person.",
            image:"oedipus.jpg")
        );
        
        Deck.m_deck.append(Card(question: "What gets wetter the more it dries?",
            answer:"A Towel.",
            image: "funny-wet-cats-36.jpg")
        );
        
        Deck.m_deck.append(Card(question: "What gets bigger the more you take out of it?",
            answer:"A Hole.",
            image: "61-bigger_dog_gets_the_bone.png")
        );
        
        Deck.m_deck.append(Card(question: "Whos that Pokemon?",
            answer:"Pikachu.",
            image: "whos-that-pokemon-pikachu.png")
        );
        
       
    }
    
    
    static func getCard()->Card{
        var currentCard:Card = m_deck[current];
        return currentCard;
    }
    
    static func getNextCard()->Card{
        current = (current+1)%m_deck.count;
        var currentCard:Card = m_deck[current];
        return currentCard;
    }
    
    static func setCardIndex(index: Int) { // you may need this function for relaunching the app
        current = index;
    }

    static func getCardIndex() -> Int {
        return current;
    }
}