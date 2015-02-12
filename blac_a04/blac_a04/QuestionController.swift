//
//  QuestionController.swift
//  blac_a04
//
//  Created by Student on 2015-02-07.
//  Copyright (c) 2015 blac2410. All rights reserved.
//

import UIKit;

class QuestionController: UITableViewController, UISearchResultsUpdating{
   
   
    
    let cellIdentifier :String = "cell";
    var m_filteredCards = [Card]();
    var resultSearchController = UISearchController();
   
   
    func makeDeck() {
        Deck.addCard(Card( question:"What's your name", answer:"Quinton Black",image:"quinton-adam.jpg", url:"http://qblack.github.io"));
        Deck.addCard(Card( question:"What School do you go to?",  answer:"WLU",image:"wilfrid_laurier_university.jpg",  url:"http://www.wlu.ca"));
        Deck.addCard(Card( question:"Whats your favourite colour?", answer:"Blue", image:"sonic.png",url:"http://en.wikipedia.org/wiki/Blue"));
        Deck.addCard(Card( question: "What place would you like to see?",  answer: "Newfoundland.",image: "ar129838104398278.jpg", url:"http://www.newfoundlandlabrador.com/PlanYourTrip/TravelBrochures?gclid=CjwKEAiAjNemBRCgp_vymcvVym0SJACRp_UZyKdWZcQIxJkOlqhPFbcyW9zYe6aZq5Oj1_ekV2HqlBoCEYzw_wcB"));
        Deck.addCard(Card( question: "What is my favourite series?",  answer: "Malazan Book of the Fallen",image: "stevenerikson.jpg", url:"http://en.wikipedia.org/wiki/Malazan_Book_of_the_Fallen"));
        Deck.addCard(Card( question:"What kind of pet do I have?", answer:"Leopard Gecko", image:"lizard.jpg",url:"http://en.wikipedia.org/wiki/Leopard_gecko"));
    }
    

    override func viewDidLoad() {
        super.viewDidLoad();
        makeDeck();
        resultSearchController  = ({
            let searchController = UISearchController(searchResultsController: nil);
            searchController.searchResultsUpdater = self;
            searchController.dimsBackgroundDuringPresentation = false;
            searchController.searchBar.sizeToFit();
            searchController.searchBar.placeholder = "Enter Text to Search...";
            self.tableView.tableHeaderView = searchController.searchBar;
            return searchController;
        })();
        
        
        self.tableView.reloadData();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    //Returns the count based on if the filtered data should be used or not
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.resultSearchController.active){
            return m_filteredCards.count;
        }
        return Deck.count();
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
            as QuestionTableCell;
        var card:Card;
        
        if(self.resultSearchController.active){
            card = m_filteredCards[indexPath.row];
        }else{
            card = Deck.getCard(indexPath.row);
        }
        cell.questionLabel?.text = card.question;
        cell.questionImage.image = UIImage(named: card.image);
        return cell;
    }
    

    // MARK: UISearchResultsUpdating Conformance
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        m_filteredCards.removeAll(keepCapacity: true)
       
        if !searchString.isEmpty {
            m_filteredCards = Deck.getCards().filter(
                {(card:Card)->Bool in
                    let question = card.question;
                    let range = question.rangeOfString(searchString,options : NSStringCompareOptions.CaseInsensitiveSearch);
                    return range != nil;
            })
        }else{
            m_filteredCards = Deck.getCards();
        }
        
        self.tableView.reloadData() // must reload data into tableView
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier=="showAnswer"{
            let indexPath = tableView.indexPathForCell(sender as UITableViewCell)!
            let answerVC = segue.destinationViewController as AnswerController;
            if(self.resultSearchController.active){
                answerVC.card = m_filteredCards[indexPath.row];
            }else{
                answerVC.card = Deck.getCard(indexPath.row);
            }
            
        }
    }
}