//
//  RSSParser.swift
//  blac_a05
//
//  Created by Quinton Black on 2015-02-23.
//  Copyright (c) 2015 Quinton Black. All rights reserved.
//

import UIKit

class RSSParser: NSObject, NSXMLParserDelegate {
    var dataStore = NSMutableData();      // to store the complete rss feed
    var parser = NSXMLParser();
    var currentElement = "";         // contains the element currently parsed by NSXMLParser
    var processingItem : Bool?;      // delete the "?", understand why there would be an error, set to true if the parser is processing the element "item"
    var itemsArray: [Story] = [Story]();  // to store the parsed items from the feed
    

    
    init(urlPath:String){
        super.init();
        processingItem = false // we could have initialize this variable in the definition, but I wanted to illustrate the optional ?
        /* for the cbc feed, try http://rss.cbc.ca/lineup/topstories.xml */
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
            println(currentElement);
            currentElement = "";
            processingItem = false;
        }
        
    } //didEndElement
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!) {
        if (processingItem!){ // we know this bool variable is never nil!
            currentElement += string
        }
    } // foundCharacters
    
    func parser(parser: NSXMLParser!, parseErrorOccurred parseError: NSError!) {
        NSLog("failure error: %@", parseError)
    }
    
    func parserDidEndDocument(parser: NSXMLParser!) {
        
    }
    
    
    func getItems() -> [Story]{
        return itemsArray;
    }
    func getItem(index : Int) -> Story{
        return itemsArray[index];
    }
    
    func numberOfElements()->Int{
        return itemsArray.count;
    }
    

   
}
