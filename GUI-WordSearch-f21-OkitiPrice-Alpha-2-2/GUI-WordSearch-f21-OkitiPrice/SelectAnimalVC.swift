//
//  SelectAnimalVC.swift
//  GUI-WordSearch-f21-OkitiPrice
//
//  Created by  on 11/21/21.
//

import UIKit

class SelectAnimalVC: UIViewController { // View controller to select animal correctly checked

    // Set of animal picture buttons
    @IBOutlet var animalPics: [UIButton]!

    // Displays whether you selected correct animal
    @IBOutlet weak var titleLabel: UILabel!

    var timer: Timer!

    var answers:[String] = []

    var randomAnimals = ["cow","rat","cat","dog","ant","bat","owl","bee"]

    var userAnimal:String = "" // correct animal
    var index = 0
    var randomAnimal_1 = ""
    var randomAnimal_2 = ""

    var pictureArray:[String] = []
    var arrayShuffled:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //randomizes animals in picture selection while garuanteeing the right answer.
        for animal in randomAnimals {
            if animal == userAnimal {
                randomAnimals.remove(at: index)
                pictureArray.append(userAnimal)
                randomAnimal_1 = randomAnimals.randomElement()!
                pictureArray.append(randomAnimal_1)
                randomAnimal_2 = randomAnimals.randomElement()!
                while randomAnimal_1 == randomAnimal_2 { // select different animal so 3 pictures have no 2 same animals
                    randomAnimal_2 = randomAnimals.randomElement()!
                }
                pictureArray.append(randomAnimal_2)
            } else {
                index += 1
            }
        }
        arrayShuffled = pictureArray.shuffled() // place animal picture in random position
        
        for i in 0...2 {
            animalPics[i].setImage(UIImage(named: arrayShuffled[i]), for: .normal)
        }
    }

    // Send back to main view controller if guessed correctly
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is ViewController {
            let vc = segue.destination as? ViewController
            vc?.answers = answers
        }
    }

    @IBAction func pictureClick(_ sender: UIButton) {
        for i in 0..<animalPics.count {
            if animalPics[i] == sender {
                if animalPics[i].currentImage! == UIImage(named: userAnimal) { // correctly picked
                    titleLabel.text = "That's correct!"
                    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(sendToVC), userInfo: nil, repeats: false) // send back to main VC
                } else { // incorrectly picked
                    titleLabel.text = "Try again..."
                }
            }
        }
    }

    @objc func sendToVC(_ t: Timer) {
        performSegue(withIdentifier: "correctAnswer", sender: self)

    }
}


