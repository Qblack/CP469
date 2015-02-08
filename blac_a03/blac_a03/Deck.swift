//
//  Deck.swift
//  blac_a03
//
//  Created by Student on 2015-02-02.
//  Copyright (c) 2015 blac2410. All rights reserved.
//

import UIKit

import Foundation

struct Deck{
    static var m_deck: [Card] = []; // a deck is an array of cards
    
    static var current:Int = 0 // the current card on the deck (to be shown in the scene)
    
    static func addCard(card:Card){
        m_deck.append(card);
    }
    
    static func getCard()->Card{
        var currentCard:Card = m_deck[current];
        return currentCard;
    }
    
    static func getCard(index:Int)->Card{
        var card:Card = m_deck[index];
        return card;
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
    
    static func count() -> Int {
        return m_deck.count;
    }
    
}