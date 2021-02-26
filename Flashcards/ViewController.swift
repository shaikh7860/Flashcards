//
//  ViewController.swift
//  Flashcards
//
//  Created by Ali Shaikh on 2/20/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var card: UIView!
    
    @IBOutlet var btnOptionOne: UIButton!
    @IBOutlet var btnOptionTwo: UIButton!
    @IBOutlet var btnOptionThree: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //Rounded Corners to Question (Label)
        card.layer.cornerRadius = 20.0
        card.clipsToBounds = true
        
        //Shadow to Question
        card.layer.shadowRadius = 15.0
        card.layer.shadowOpacity = 0.2
        frontLabel.clipsToBounds = true
        backLabel.clipsToBounds = true
        
        //Rounded Corners on answer buttons
        btnOptionOne.layer.borderWidth = 3.0
        btnOptionOne.layer.borderColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        btnOptionTwo.layer.borderWidth = 3.0
        btnOptionTwo.layer.borderColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        btnOptionThree.layer.borderWidth = 3.0
        btnOptionThree.layer.borderColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        

    }

    @IBAction func didTapOnFlashcard(_ sender: Any) {
        if(frontLabel.isHidden == true){
            frontLabel.isHidden = false
        }
        else{
            frontLabel.isHidden = true
        }
    }
    
    
    
}
