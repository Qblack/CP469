//
//  ViewController.swift
//  blac_a1
//
//  Created by Quinton Black on 2015-01-19.
//  Copyright (c) 2015 Quinton Black. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    struct Question {
        var question:String;
        var answer:String;
        var image_name:String;
    }
    var questions:[Question] = []
    var index:Int = 0;
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    func makeQuestions(){
        questions.append(Question(question:"What is my name?", answer:"Quinton Black",image_name:"quinton.black.jpg"));
        
        questions.append(Question(question:"What is my favourite colour?",answer:"Blue",image_name:"blue-frog.jpg"));
        
        questions.append(Question(question:"What school do I go to?", answer:"WLU",image_name:"wlulogo.jpg"));
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        makeQuestions();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showQuestion(sender: UIButton) {
        var question = questions[index];
        questionLabel.text = question.question;
        var nextImage = UIImage(named: question.image_name);
        image.image = nextImage; // set UIImageView to UIImage
        answerLabel.text="???";
        
        
        index = (index+1)%questions.count;
        
    }

    @IBAction func showAnswer(sender: UIButton) {
        var question = questions[(index-1)%questions.count];
        answerLabel.text = question.answer;
    }
    
    
}

