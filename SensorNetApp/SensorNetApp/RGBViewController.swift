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
    
    let updateUrlFast = "http://192.168.0.100:5000/updateControlFast"
    var moduleInfo = ModuleInfo()
    var pageTitle = ""
    var helpVisible = false
    var help: UIView!
    var helpDesc: UILabel!
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //gradients: http://www.reddit.com/r/swift/comments/27mrlx/gradient_background_of_uiview_in_swift/
        let gradient : CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        let cor1 = UIColor(white: 0.1, alpha: 0.98).CGColor
        let cor2 = UIColor(white: 0.5, alpha: 0.98).CGColor
        let arrayColors = [cor1, cor2]
        gradient.colors = arrayColors
        view.layer.insertSublayer(gradient, atIndex: 0)
        
        header.title = moduleInfo.name
        nodeIdLabel.text = moduleInfo.Id
        moduleIdLabel.text = moduleInfo.moduleId
        sensorsLabel.text = ModuleStatus(rawValue: moduleInfo.nodeStatus.toInt()!)?.toString
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = moduleInfo.description
        
        let color = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        colorShow.backgroundColor = color
        
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
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent) {
        if (!helpVisible) {
            if motion == .MotionShake {
                shakeUI.alpha = 0.95
                var timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("hideOverlay"), userInfo: nil, repeats: false)
            }
        }
    }
    
    func hideOverlay() {
        //  PopUpView.hidden = true
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.shakeUI.alpha = 0.0
            }, completion: {finished in
                self.createRandomColor()})
    }
    
    func createRandomColor() {
        //create random colour on shake gesture
        let randRed = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        let randGreen = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        let randBlue = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        
        redSlider.value = Float(randRed)
        greenSlider.value = Float(randGreen)
        blueSlider.value = Float(randBlue)
        displayColors()
        
        let red = CGFloat(redSlider.value)
        let blue = CGFloat(blueSlider.value)
        let green = CGFloat(greenSlider.value)
        
        requestUpdateLight(red, green: green, blue: blue)
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
    
    @IBAction func helpClicked(sender: UIButton) {
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
