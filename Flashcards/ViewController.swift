//
//  ViewController.swift
//  Flashcards
//
//  Created by Ali Shaikh on 2/20/21.
//

import UIKit

struct Flashcard{
    var question: String
    var answer: String
    var extraAnswer1 : String
    var extraAnswer2 : String
}

class ViewController: UIViewController {

    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var card: UIView!
    
    @IBOutlet var btnOptionOne: UIButton!
    @IBOutlet var btnOptionTwo: UIButton!
    @IBOutlet var btnOptionThree: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    
    
    //Array to hold our flashcards
    var flashcards = [Flashcard]()
    
    //Current flashcard index
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                
        //Read Saved flashcards
        readSavedFlashacards()
        
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
        btnOptionOne.layer.cornerRadius = 10.0
        btnOptionTwo.layer.borderWidth = 3.0
        btnOptionTwo.layer.borderColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        btnOptionTwo.layer.cornerRadius = 10.0
        btnOptionThree.layer.borderWidth = 3.0
        btnOptionThree.layer.borderColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        btnOptionThree.layer.cornerRadius = 10.0
        
        //inital state of flashcard when app is launched
        //updateFlashcard(question: "What's the capital of Brazil?", answer: "Brasilia", extraAnswerOne: "Rio", extraAnswerTwo: "Sao Paulo")
    }
    override func viewDidAppear(_ animated: Bool) {
        //Adding our initial flashcard if needed
        if flashcards.count == 0{
        //updateFlashcard(question: "What's the capital of Brazil?", answer: "Brasilia", extraAnswerOne: "Rio de Janero" , extraAnswerTwo: "Sao Paolo")
            performSegue(withIdentifier: "newFlashcard", sender: self)
            print("flashcard0")
        }else{
            updateLabels()
            updateNextPrevButtons()
            print("flashcard1")
        }
    }

    @IBAction func didTapOnFlashcard(_ sender: Any) {
        flipFlashcard()
    }
    
    func flipFlashcard(){
        if(frontLabel.isHidden == true){
            frontLabel.isHidden = false
        }
        else{
            frontLabel.isHidden = true
        }
        
        UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromRight, animations: {
                self.frontLabel.isHidden = true
        })
    }
    
    //Handles the animation of clicking from flashcard to flashcard
    func animateCardOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
        }, completion: { finished in
            
            self.updateLabels()
            self.animateCardIn()
        })
    }
    
    func animateCardIn(){
        card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
        
        
        UIView.animate(withDuration: 0.3) {
            self.card.transform = CGAffineTransform.identity
        }
    }
    
    
    func updateFlashcard(question: String, answer: String, extraAnswerOne: String, extraAnswerTwo: String){
        let flashcard = Flashcard(question: question, answer: answer, extraAnswer1: extraAnswerOne, extraAnswer2: extraAnswerTwo)
        frontLabel.text = flashcard.question
        backLabel.text = flashcard.answer

        btnOptionOne.setTitle(extraAnswerOne, for: .normal)
        btnOptionTwo.setTitle(answer, for: .normal)
        btnOptionThree.setTitle(extraAnswerTwo, for: .normal)
        
        //Adding flashcard in the flashcards array
        flashcards.append(flashcard)
        
        //Logging to the console
        print("Added new flashcard")
        print("We now have \(flashcards.count) flashcards")
        
        //Update current index
        currentIndex = flashcards.count - 1
        print("Our current index is \(currentIndex)")
        
        //Update buttons
        updateNextPrevButtons()
        
        //Update labels
        updateLabels()
        
        //Save the flashcard to disk
        saveAllFlashcardsToDisk()
        
    }
    
    //Update the labels
    func updateLabels(){
        //Get current flashcard
        let currentFlashcard = flashcards[currentIndex]
        
        //Update labels
        frontLabel.text = currentFlashcard.question
        backLabel.text = currentFlashcard.answer
        
        btnOptionOne.setTitle(currentFlashcard.extraAnswer1, for: .normal)
        btnOptionTwo.setTitle(currentFlashcard.answer, for: .normal)
        btnOptionThree.setTitle(currentFlashcard.extraAnswer2, for: .normal)
    }
    
    
    //If button one is tappped it disappears
    @IBAction func didTapButtonOne(_ sender: Any) {
        btnOptionOne.isHidden = true
    }
    
    //If button two is tapped, button 1,3 disappears
    @IBAction func didTapButtonTwo(_ sender: Any) {
        frontLabel.isHidden = true
        btnOptionOne.isHidden = true
        btnOptionThree.isHidden = true
        
    }
    
    //If button three is tappped it disappears
    @IBAction func didTapButtonThree(_ sender: Any) {
        btnOptionThree.isHidden = true
    }
    
    //Segue function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //We know the destination of the segue is the Navigation Controller
        let navigationController = segue.destination as! UINavigationController
        
        //We know the Navigation Controller only contains a Creation View Controller
        let creationController = navigationController.topViewController as! CreationViewController
        
        //We set the flashcardsController property to self
        creationController.flashcardsController = self
    }
    
    //Next button
    @IBAction func didTapOnNext(_ sender: Any) {
        //Increase current index
        currentIndex = currentIndex + 1
        
        //Update labels
        updateLabels()
        
        //Update buttons
        updateNextPrevButtons()
        
        btnOptionOne.isHidden = false
        btnOptionTwo.isHidden = false
        btnOptionThree.isHidden = false
        
        animateCardOut()
        
    }
    
    //Prev Button
    @IBAction func didTapOnPrev(_ sender: Any) {
        //Decrease current index
        currentIndex = currentIndex - 1
        
        //Update labels
        updateLabels()
        
        //Update buttons
        updateNextPrevButtons()
        
        btnOptionOne.isHidden = false
        btnOptionTwo.isHidden = false
        btnOptionThree.isHidden = false
    }
    
    //Delete Button
    @IBAction func didTapOnDelete(_ sender: Any) {
        //Show confirmation
        let alert = UIAlertController(title: "Delete flashcard", message: "Are you sure you want to delete it?", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            self.deleteCurrentFlashcard()
        }
        alert.addAction(deleteAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        present(alert, animated: true)
        
    }
    
    func deleteCurrentFlashcard(){
        //Delete current
        flashcards.remove(at: currentIndex)
        
        //Special case: Check if last card was deleted
        if currentIndex > flashcards.count - 1{
            currentIndex = flashcards.count - 1
        }
        updateNextPrevButtons()
        updateLabels()
        saveAllFlashcardsToDisk()
    }
    
    
    //Update the Next and Previous buttons
    func updateNextPrevButtons(){
        //Disable next button if at the end
        if(currentIndex == flashcards.count - 1){
            nextButton.isEnabled = false
        } else{
            nextButton.isEnabled = true
        }
        //Disable prev button if at the beggining
        if(currentIndex == 0){
            prevButton.isEnabled = false
        }else{
            prevButton.isEnabled = true
        }
    }
    
    //Saving the flashcards to disk
    func saveAllFlashcardsToDisk(){
        //From flashcard array to dictionary array
        let dictionaryArray = flashcards.map { (card) -> [String: String] in
            return ["question": card.question, "answer": card.answer, "extra answer one": card.extraAnswer1, "extra answer two": card.extraAnswer2]
        }
        //Save array on disk using UserDefaults
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
        
        //Log it
        print("Flashcards save to UserDefaults")
    }
    
    //Reading the saved flashcards from disk
    func readSavedFlashacards(){
        //Read dictionary array from disk (if any)
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String: String]]{
            //In here we know for sure that we have a dictionary
            let savedCards = dictionaryArray.map{ dictionary -> Flashcard in
                return Flashcard(question: dictionary["question"] ?? "", answer: dictionary["answer"] ?? "", extraAnswer1: dictionary["extra answer one"] ?? "", extraAnswer2: dictionary["extra answer two"] ?? "")
            }
            //Put all of these cards in our flashcards array
            flashcards.append(contentsOf: savedCards)
            print(flashcards)
        }
        
    }
}
