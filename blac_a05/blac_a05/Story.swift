//
//  Story.swift
//  blac_a05
//
//  Created by Quinton Black on 2015-02-23.
//  Copyright (c) 2015 Quinton Black. All rights reserved.
//

import UIKit

class Story: NSObject {
    var title: NSString = "";
    var url : NSString = "";
    var image: NSString = "";
    var content: NSString = "";
    let urlPattern = "http:.*cmp=rss";
    
    init(content: NSString){
        super.init();
        self.url = parseOutURL(content);
        println(self.url);
        
    }
    func parseOutURL(content: String)->String{
        var error: NSError? = nil;
        var regex = NSRegularExpression(pattern: urlPattern, options: nil, error: &error)
        var match : NSTextCheckingResult? = regex?.firstMatchInString(content, options: nil, range: NSRange(location:0,length:countElements(content)));
        var range = match?.range;
        var data : NSString = content as NSString;
        
        var result: String = data.substringWithRange(range!);
        
        return result;
    }
    
    

}
