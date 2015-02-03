//
//  PickerViewController.swift
//  blac_a03
//
//  Created by Student on 2015-02-02.
//  Copyright (c) 2015 blac2410. All rights reserved.
//

import UIKit;

class PickerViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate  {
    
    @IBOutlet weak var m_image: UIImageView!
    @IBOutlet weak var m_picker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        m_picker.delegate = self
        m_picker.dataSource = self

        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    @IBAction func showAnswer(sender: UIButton) {
    }
    
    func displayCard(card: Card){
     
    }

}