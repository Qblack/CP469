//
//  StoriesTableViewController.swift
//  blac_a05
//
//  Created by Quinton Black on 2015-02-23.
//  Copyright (c) 2015 Quinton Black. All rights reserved.
//

import UIKit

class StoriesTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate, NSXMLParserDelegate {
    
    var CBC_RSS = "http://rss.cbc.ca/lineup/topstories.xml";
    var dataStore = NSMutableData();      // to store the complete rss feed
    var parser = NSXMLParser();
    var currentElement = "";         // contains the element currently parsed by NSXMLParser
    var processingItem : Bool?;      // delete the "?", understand why there would be an error, set to true if the parser is processing the element "item"
    var itemsArray: [Story] = [Story]();  // to store the parsed items from the feed
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.initialiezeParser(CBC_RSS);
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // Return the number of rows in the section.
        return self.itemsArray.count;
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell;
        cell.textLabel?.text = self.itemsArray[indexPath.row].title.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet());
        
        return cell;
    }
    
    func initialiezeParser(urlPath:String){

        processingItem = false
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
        var url: NSURL = NSURL(string: urlPath)!;
        var request: NSURLRequest = NSURLRequest(URL: url);
        var connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: true)!;
        connection.start()
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        self.dataStore.appendData(data);
    }
    
    func connection(connection: NSURLConnection!, didFailWithError error: NSError!) {
        NSLog("Connection failed.\(error.localizedDescription)")
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
        var results = NSString(data: dataStore, encoding: NSUTF8StringEncoding);
        // start the parser
        parser = NSXMLParser(data: dataStore);
        parser.delegate = self;      // don't forget to set the delegate for the parser
        parser.parse();
        
    } // connectionDidFinishLoading
    
    
    func parser(parser: NSXMLParser!,didStartElement elementName: String!, namespaceURI: String!, qualifiedName : String!, attributes attributeDict: NSDictionary!) {
        if elementName == "item" {
            processingItem = true;
        }
    } // didStartElement
    
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        
        if elementName == "item"{
            var story : Story = Story(data:currentElement);
            itemsArray.append(story);
            currentElement = "";
            processingItem = false;
        }
        
    } //didEndElement
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!) {
        if (processingItem!){ // we know this bool variable is never nil!
            currentElement += string;
        }
    } // foundCharacters
    
    func parser(parser: NSXMLParser!, parseErrorOccurred parseError: NSError!) {
        NSLog("failure error: %@", parseError);
    }
    
    func parserDidEndDocument(parser: NSXMLParser!) {
        tableView.reloadData();
    }
    
    
    /*
    // MARK: - Navigation
    */
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        let indexPath = tableView.indexPathForCell(sender as UITableViewCell)!
        let storyViewController = segue.destinationViewController as StoryViewController;
        storyViewController.story = self.itemsArray[indexPath.row];
        
    }
    @IBAction func unwindToHome(unwindSegue: UIStoryboardSegue){
        
    }
    


}
