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
    @IBOutlet weak var header: UINavigationItem!
    
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var colorShow: UILabel!
    
    var moduleInfo = ModuleInfo()
    var pageTitle = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        header.title = pageTitle
        nodeIdLabel.text = moduleInfo.Id
        moduleIdLabel.text = moduleInfo.moduleId
        sensorsLabel.text = moduleInfo.nodeStatus
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = moduleInfo.description
        
        let color = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        colorShow.backgroundColor = color
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
    
    @IBAction func redSliderChanged(sender: UISlider) {
        displayColors()
    }
    
    @IBAction func greenSliderChanged(sender: UISlider) {
        displayColors()
    }
    
    @IBAction func blueSliderChanged(sender: UISlider) {
        displayColors()
    }
    
    func displayColors(){
        let red = CGFloat(redSlider.value)
        let blue = CGFloat(blueSlider.value)
        let green = CGFloat(greenSlider.value)
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        
        colorShow.backgroundColor = color
    }

    @IBAction func handleColourChange(sender: UIButton) {
         println(sender.backgroundColor)
        var colour :UIColor = sender.backgroundColor!
        var red : CGFloat = 0.0
        var green :CGFloat = 0.0
        var blue : CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        colour.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        redSlider.value = Float(red)
        greenSlider.value = Float(green)
        blueSlider.value = Float(blue)
        
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        colorShow.backgroundColor = color
    }
    

}
