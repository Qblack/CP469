//
//  QuestionController.swift
//  blac_a04
//
//  Created by Student on 2015-02-07.
//  Copyright (c) 2015 blac2410. All rights reserved.
//

import UIKit;

class QuestionController: UITableViewController {
    
    
  
//    var searchController: UISearchController!
    let cellIdentifier :String = "cell";

    
   
    func makeDeck() {
        Deck.addCard(Card( question:"What's your name", answer:"Quinton Black",image:"quinton-adam.jpg", url:"http://qblack.github.io"));
        Deck.addCard(Card( question:"What School do you go to?",  answer:"WLU",image:"wilfrid_laurier_university.jpg",  url:"http://www.wlu.ca"));
        Deck.addCard(Card( question:"Whats your favourite colour?", answer:"Blue", image:"sonic.png",url:"http://en.wikipedia.org/wiki/Blue"));
        Deck.addCard(Card( question: "What place would you like to see?",  answer: "Newfoundland.",image: "ar129838104398278.jpg", url:"http://www.newfoundlandlabrador.com/PlanYourTrip/TravelBrochures?gclid=CjwKEAiAjNemBRCgp_vymcvVym0SJACRp_UZyKdWZcQIxJkOlqhPFbcyW9zYe6aZq5Oj1_ekV2HqlBoCEYzw_wcB"));

    }
    

    override func viewDidLoad() {
        super.viewDidLoad();
        makeDeck();
       
        //let resultsController = SearchResultsController()
        //resultsController.names = Deck.getQuestions();
        //searchController = UISearchController(searchResultsController: resultsController)
        
        //let searchBar = searchController.searchBar
        //searchBar.placeholder = "Enter a search term"
       // searchBar.sizeToFit()
        //tableView.tableHeaderView = searchBar
       // searchController.searchResultsUpdater = resultsController
        
        
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
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Deck.count();
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
            as QuestionTableCell;
        var card:Card = Deck.getCard(indexPath.row);
        cell.questionLabel?.text = card.question;
        cell.questionImage.image = UIImage(named: card.image);
        
        
        return cell;
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier=="showAnswer"{
            let indexPath = tableView.indexPathForCell(sender as UITableViewCell)!
            let answerVC = segue.destinationViewController as AnswerController
            answerVC.index = indexPath.row
        }
    }
}