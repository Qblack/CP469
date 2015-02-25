//
//  Story.swift
//  blac_a05
//
//  Created by Quinton Black on 2015-02-23.
//  Copyright (c) 2015 Quinton Black. All rights reserved.
//

import UIKit

class Story: NSObject {
    var title: String = "";
    var url : String = "";
    var imageUrl: String = "";
    var content: String = "";

    private let urlPattern = "http:.*cmp=rss";
    private let imagePattern = "src='.*' ";
    private let contentPattern = "<p>.*</p>";
    
    init(data: String){
        super.init();
        //Parse out data with regex
        self.url = getMatchingString(urlPattern, string: data);
        self.imageUrl = parseImageURL(imagePattern,string:data);
        self.content = parseContents(contentPattern, string: data);
        var dataArray = data.componentsSeparatedByString("\n");
        self.title = dataArray[1];
    }
    
    override init(){
        super.init();
    }
    
    
    private func parseImageURL(pattern: String, string:String )-> String{
        var image:String = getMatchingString(pattern, string: string);
        var imageUrlStartIndex = advance(image.startIndex,5);
        image = image.substringFromIndex(imageUrlStartIndex);
        var imageUrlEndIndex = advance(image.endIndex, -2);
        image = image.substringToIndex(imageUrlEndIndex);
        return image;
    }
    
    private func parseContents(pattern: String, string:String )-> String{
        var taggedContent:String = getMatchingString(pattern, string: string);
        var startIndex = advance(taggedContent.startIndex,3);
        taggedContent = taggedContent.substringFromIndex(startIndex);
        var endIndex = advance(taggedContent.endIndex, -4);
        taggedContent = taggedContent.substringToIndex(endIndex);
        return taggedContent;
    }
    
    
    private func getMatchingString(pattern: String, string:String )->String{
        var error: NSError? = nil;
        var regex = NSRegularExpression(pattern: pattern, options: nil, error: &error)
        var match : NSTextCheckingResult? = regex?.firstMatchInString(string, options: nil, range: NSRange(location:0,length:countElements(string)));
        var range = match?.range;
        var data : NSString = string as NSString;
        var result: String = data.substringWithRange(range!);
        return result;
}
    
    

}
