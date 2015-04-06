//
//  LoadingViewController.swift
//  SensorNetApp
//
//  Created by Quinton Black on 2015-04-06.
//  Copyright (c) 2015 Quinton and Brian. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        image.animationImages = [UIImage]()
        image.animationImages?.append(UIImage(named: "led-light")!)
        image.animationImages?.append(UIImage(named: "led-normal")!)
        image.animationImages?.append(UIImage(named: "led-dark")!)
        image.animationImages?.append(UIImage(named: "led-normal")!)
        image.animationDuration = 1
        image.startAnimating()


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

}
