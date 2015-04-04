//
//  RGBViewController.swift
//  SensorNetApp
//
//  Created by Quinton Black on 2015-03-28.
//  Copyright (c) 2015 Quinton and Brian. All rights reserved.
//

/* Title:       RGBViewController.swift
 * Date:        March 28, 2015
 * Author:      Brian Sage and Quinton Black
 * Description: This is the view controller file for the RGB light strip.
 *              It contains all the methods necessary to control the UI and interact
 *              with the user. It also contains the method that will go out and get
 *              the specific module information we're interested in.
 */

import UIKit

class RGBViewController: UIViewController {
    
    //GUI variables
    @IBOutlet weak var nodeIdLabel: UILabel!
    @IBOutlet weak var moduleIdLabel: UILabel!
    @IBOutlet weak var sensorsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var header: UINavigationItem!
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var colorShow: UILabel!
    @IBOutlet weak var shakeUI: UIView!
    
    //variables
    let updateUrlFast = "http://192.168.0.100:5000/updateControlFast"
    var moduleInfo = ModuleInfo()
    var pageTitle = ""
    var helpVisible = false
    var help: UIView!
    var helpDesc: UILabel!
    
    /*
    *  This method allows for the shake gesture to be used
    */
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create gradient background
        //gradients: http://www.reddit.com/r/swift/comments/27mrlx/gradient_background_of_uiview_in_swift/
        let gradient : CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        let cor1 = UIColor(white: 0.1, alpha: 0.98).CGColor
        let cor2 = UIColor(white: 0.5, alpha: 0.98).CGColor
        let arrayColors = [cor1, cor2]
        gradient.colors = arrayColors
        view.layer.insertSublayer(gradient, atIndex: 0)
        
        //set all the label texts from the module info
        header.title = moduleInfo.name
        nodeIdLabel.text = moduleInfo.Id
        moduleIdLabel.text = moduleInfo.moduleId
        sensorsLabel.text = ModuleStatus(rawValue: moduleInfo.nodeStatus.toInt()!)?.toString
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = moduleInfo.description
        
        //init the selected colour box
        let color = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        colorShow.backgroundColor = color
        
        //make the shake overlay invisible
        shakeUI.alpha = 0
        
        //create help dialog
        help = UIView(frame: CGRectMake(20, 100, self.view.bounds.width - 40, 0))
        help.backgroundColor = UIColor(white: 0.5, alpha: 0.98)
        self.view.addSubview(help)
        
        helpDesc = UILabel(frame: CGRectMake(15, 10, help.bounds.width - 15, self.view.bounds.height * 0.5))
        helpDesc.textAlignment = NSTextAlignment.Left
        helpDesc.numberOfLines = 0
        helpDesc.textColor = UIColor.whiteColor()
        helpDesc.font = UIFont(name: "System", size: CGFloat(22))
        helpDesc.text = "RGB Lights\n\n\nFrom here you can control the colour of the LED strip lights.\n\nYou can either change the RGB values using the sliders, or you can choose from one of the pre-generated colours.\n\nFor extra fun, try shaking the phone!"
        help.addSubview(helpDesc)
        helpDesc.alpha = 0
    }
    
    /*
    *  This method executes when a shake gesture is recognized.
    */
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent) {
        if (!helpVisible) {
            if motion == .MotionShake {
                //show the shake overlay
                shakeUI.alpha = 0.95
                
                //schedule a task to make it fade after 1 second
                var timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("hideOverlay"), userInfo: nil, repeats: false)
            }
        }
    }
    
    /*
    *  This method makes the shake overlay fade away
    */
    func hideOverlay() {
        //animate the fading of the shake overlay
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.shakeUI.alpha = 0.0
            }, completion: {finished in
                //create random colour
                self.createRandomColor()})
    }
    
    /*
    *  This method creates a random colour using RGB, displays it, and 
    *  calls the webservice to change the LED light strip.
    */
    func createRandomColor() {
        //create random colour on shake gesture
        let randRed = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        let randGreen = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        let randBlue = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        
        //update the slider values with the new colour
        redSlider.value = Float(randRed)
        greenSlider.value = Float(randGreen)
        blueSlider.value = Float(randBlue)
        displayColors()
        
        requestUpdateLight(randRed, green: randGreen, blue: randBlue)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    *  This method executes when the display button is clicked
    */
    @IBAction func displayClicked(sender: AnyObject) {
        //get RGB values from sliders
        let red = CGFloat(redSlider.value)
        let blue = CGFloat(blueSlider.value)
        let green = CGFloat(greenSlider.value)
        
        //call webservice to update LED light strip
        requestUpdateLight(red, green: green, blue: blue)
    }
    
    /*
    *  This method executes whenever any of the slider values have changed.
    */
    @IBAction func sliderChanged(sender: UISlider) {
        displayColors()
    }
    
    /*
    *  This method gets the colour from the sliders and displays it on the screen.
    */
    func displayColors(){
        let red = CGFloat(redSlider.value)
        let blue = CGFloat(blueSlider.value)
        let green = CGFloat(greenSlider.value)
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        
        colorShow.backgroundColor = color
    }

    /*
    *  This method executes when the user clicks one of the pre-gen
    *  colours.
    */
    @IBAction func handleColourChange(sender: UIButton) {
        //vars
        var colour: UIColor = sender.backgroundColor!
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        //get the colour selected
        colour.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        //set the slider values to the new colour
        redSlider.value = Float(red)
        greenSlider.value = Float(green)
        blueSlider.value = Float(blue)
        displayColors()
        
        //call the webservice to update the LED light strip
        requestUpdateLight(red, green: green, blue: blue)
    }
    
    /*
    *  This method creates the params to send to the web service
    */
    func requestUpdateLight(red: CGFloat, green: CGFloat, blue: CGFloat) {
        let r = Int(red * 255)
        let g = Int(green * 255)
        let b = Int(blue * 255)
        
        //create params to send to webservice
        var params: Dictionary<String, NSObject> = ["moduleID":moduleInfo.moduleId, "commands":[16], "values":[r, g, b]]
        
        //call service
        updateControlFast(params)
    }
    
    /*
    *  This method makes the POST request to the webservice.
    */
    func updateControlFast(params : Dictionary<String, NSObject>) {
        //create http request using POST
        var req = NSMutableURLRequest(URL: NSURL(string: updateUrlFast)!)
        var session = NSURLSession.sharedSession()
        req.HTTPMethod = "POST"
        
        //create body and header of request
        var err: NSError?
        req.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //make the request
        var task = session.dataTaskWithRequest(req, completionHandler: {data, response, error -> Void in
            //print that we changed the color
            //we only ever get back 1, so there's nothing we can do or know
            //if it didn't actually change the light
            println("Changed color of LEDs.")
        })
        
        task.resume()
    }
    
    /*
    *  This method executes when the help (?) button is pressed
    */
    @IBAction func helpClicked(sender: UIButton) {
        //toggle the boolean value
        helpVisible = !helpVisible
        
        //show or hide the help dialog
        if (helpVisible) {
            UIView.animateWithDuration(2, animations: {
                self.help.frame.size = CGSizeMake(self.view.bounds.width - 40, self.view.bounds.height - 120)
            })
            UIView.animateWithDuration(1, delay: 1, options: nil, animations: {
                self.helpDesc.alpha = 1
                }, completion: nil)
        }
        else {
            UIView.animateWithDuration(2, animations: {
                self.help.frame.size = CGSizeMake(self.view.bounds.width - 40, 0)
            })
            UIView.animateWithDuration(1, animations: {
                self.helpDesc.alpha = 0
            })
        }
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
