//
//  QuizTableViewController.swift
//  blac_q04
//
//  Created by Quinton Black on 2015-02-26.
//  Copyright (c) 2015 Quinton Black. All rights reserved.
//

import UIKit

class QuizTableViewController: UITableViewController {

    var data = ["1","2","3"];
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.data.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = data[indexPath.row];

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let controller = UIAlertController(title: "Row Selected",
            message: "You seceted \(self.data[indexPath.row])", preferredStyle: .Alert);
            
        let action = UIAlertAction(title: "Yes I did",style: .Default, handler: nil);
        
        controller.addAction(action)
        
        presentViewController(controller, animated: true, completion: nil)

    }
}
