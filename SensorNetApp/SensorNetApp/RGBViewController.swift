//
//  RGBViewController.swift
//  SensorNetApp
//
//  Created by Quinton Black on 2015-03-28.
//  Copyright (c) 2015 Quinton and Brian. All rights reserved.
//

import UIKit

class RGBViewController: UIViewController {
    
    @IBOutlet weak var nodeIdLabel: UILabel!
    @IBOutlet weak var moduleIdLabel: UILabel!
    @IBOutlet weak var sensorsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var moduleInfo = ModuleInfo()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

    @IBAction func handleColourChange(sender: UIButton) {
         println(sender.backgroundColor)
        var colour :UIColor = sender.backgroundColor!
        var red : CGFloat = 0.0
        var green :CGFloat = 0.0
        var blue : CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        colour.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        println(red)
        println(green)
        println(blue)
        
        
        
    }
    

}
