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
    
    let updateUrlFast = "http://192.168.0.100:5000/updateControlFast"
    var moduleInfo = ModuleInfo()
    var pageTitle = ""
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent) {
        if motion == .MotionShake {
            //FIXlet randRed: Float = Float((arc4random_uniform(255) + 1) / 255)
            let randGreen = arc4random_uniform(255) + 1
            let randBlue = arc4random_uniform(255) + 1
            
            redSlider.value = randRed
            greenSlider.value = Float(randGreen)
            blueSlider.value = Float(randBlue)
            displayColors()

        }
    }

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
    
    @IBAction func displayClicked(sender: AnyObject) {
        let red = CGFloat(redSlider.value)
        let blue = CGFloat(blueSlider.value)
        let green = CGFloat(greenSlider.value)
        
        requestUpdateLight(red, green: green, blue: blue)
    }
    
    @IBAction func sliderChanged(sender: UISlider) {
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
        var colour: UIColor = sender.backgroundColor!
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        colour.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        redSlider.value = Float(red)
        greenSlider.value = Float(green)
        blueSlider.value = Float(blue)
        displayColors()
        
        requestUpdateLight(red, green: green, blue: blue)
    }
    
    func requestUpdateLight(red: CGFloat, green: CGFloat, blue: CGFloat) {
        let r = Int(red * 255)
        let g = Int(green * 255)
        let b = Int(blue * 255)
        
        var params: Dictionary<String, NSObject> = ["moduleID":moduleInfo.moduleId, "commands":[16], "values":[r, g, b]]
        updateControlFast(params)
    }
    
    func updateControlFast(params : Dictionary<String, NSObject>) {
        var req = NSMutableURLRequest(URL: NSURL(string: updateUrlFast)!)
        var session = NSURLSession.sharedSession()
        req.HTTPMethod = "POST"
        
        var err: NSError?
        req.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var task = session.dataTaskWithRequest(req, completionHandler: {data, response, error -> Void in
            //print that we changed the color
            //we only ever get back 1, so there's nothing we can do or know
            //if it didn't actually change the light
            println("Changed color of LEDs.")
        })
        
        task.resume()
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
}
