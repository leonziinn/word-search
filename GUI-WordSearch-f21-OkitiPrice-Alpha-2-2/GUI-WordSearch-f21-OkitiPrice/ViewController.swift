//
//  ViewController.swift
//  GUI-WordSearch-f21-OkitiPrice
//
//  Created by  on 11/14/21.
//
/*
 Connor Price & Leo Okiti
 */

import AVFoundation
import UIKit

class ViewController: UIViewController {

    //label above the answer box
    @IBOutlet weak var answerLabel: UILabel!
    
    //Matrix of buttons that randomly change letters
    @IBOutlet var buttonMatrix: [UIButton]!
    
    //Used to limit the number of letters in the answerBox
    var count = 0
    
    //This variable allows the use of audio
    var AppSpeaker: AVAudioPlayer!
    
    //This is the answer box
    @IBOutlet weak var answerBox: UITextView!
    
    //array of the possible animals
    var answers = ["cow","rat","cat","dog","ant","bat","owl","bee"]
    
    //array of letters to choose from
    var letters: [String] = ["O","Z","B","Y","T","D","U","R","E","N","C","W","A","L","G"]
    
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //sets the background of the main VC
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bear")!)
        
        //Shuffles the letters on button tiles each round
        letters.shuffle()
        for i in 0...14 {
            buttonMatrix[i].setTitle(letters[i], for: .normal)
        }
        
        //Checks to see if the user has guessed all animals
        if answers.isEmpty {
            answerLabel.text = "You win!"
        }
        
    }
    
    //Moves to AnimalVC once the user correctly guesses an animal
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is SelectAnimalVC {
            let vc = segue.destination as? SelectAnimalVC
            vc?.answers = answers
            vc?.userAnimal = answerBox.text.lowercased()
        }
    }
    
    //Clears text entered in answerBox
    @IBAction func clearPressed(_ sender: Any) {
        answerBox.text = ""
        count = 0
    }
    
    //Enters selected letter into answer box upon pressing button
    @IBAction func letterPressed(_ sender: UIButton) {
        
        for i in 0..<buttonMatrix.count {
            
            //checks which button is pressed
            if buttonMatrix[i] == sender {
                if count == 0 { // check thst answerBox is empty
                    answerBox.text = "\(buttonMatrix[i].titleLabel!.text!)"
                }
                if count > 0 && count < 3 { // add next pressed letter to previously entered letter
                    answerBox.text = "\(answerBox.text!)\(buttonMatrix[i].titleLabel!.text!)"
                }
                count += 1

            }
        }
    }
    //plays sound the remaining animals make
    @IBAction func hintPressed(_ sender: UIButton) {
        do {
            
            //brings in sound files
            AppSpeaker = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: answers.randomElement()!, ofType: "mp3")!))
            AppSpeaker?.play()
        }
        catch {
            
        }
    }
    //checks the text in the answer box for the correct answer
    @IBAction func checkAnswerButton(_ sender: UIButton) {
        for animal in answers {
            
            //allows for any captilization
            if answerBox.text.lowercased() == animal {
                answerLabel.text = "That's correct!"
                

                answers = answers.filter { $0 != animal }

                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(sendToVC), userInfo: nil, repeats: false)
                
            }
            
            
        }
    }
    
    //resets main VC
    @objc func sendToVC(_ t: Timer) {
        performSegue(withIdentifier: "pickAnimal", sender: self)
        answerLabel.text = "Enter your Answer: "
        count = 0
    }
    
}

