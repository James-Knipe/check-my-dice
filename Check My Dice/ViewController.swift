//
//  ViewController.swift
//  BGB Dice Checker
//
//  Created by James Knipe on 20/05/2017.
//  Copyright © 2017 James Knipe. All rights reserved.
//

import UIKit
import GameKit

var seedInt = 0
var minValue = 1
var maxValue = 6
// var initialText = "Generate the first 1000 numbers using the Mersenne Twister random number generator.\nIf you are checking backgammon rolls from BG Buddy:\n1) Export your match dice rolls from the BG Buddy Saved Matches folder.\n2) Enter the seed from the exported email.\n3) Compare the rolls generated here to the dice text file attachment in the email.\n\nTap the BGB icon above to download BG Buddy."

var initialText = "Mersenne Twister random number generator.\n\nEnter a seed to generate the first 1000 numbers.\nTo check backgammon rolls from BG Buddy:\n1) Export your match dice rolls from the BG Buddy Saved Matches folder.\n2) Enter the seed from the exported email.\n3) Compare the rolls generated here to the dice text file attachment in the email.\n\nTap the BGB icon above to download BG Buddy."

class ViewController: UIViewController, UITextFieldDelegate {
  
  
  @IBOutlet weak var seed: UITextField!
  @IBOutlet weak var numbersView: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // initialise variables
    seed.delegate = self
    let myColor : UIColor = UIColor(red: 1.0, green: 236.0/255.0, blue: 0, alpha: 1.0)
    seed.layer.cornerRadius = 6.0;
    seed.layer.masksToBounds = true;
    seed.layer.borderWidth = 1;
    seed.layer.borderColor = myColor.cgColor
    numbersView.text = initialText;
  }
  
  @IBAction func generate1000NumbersFromSeed() {
    numbersView.text = ""
    //   seed.resignFirstResponder()
    if seed.text != "" {
      //convert seed text string to a number
      let seedInt = UInt64(seed.text!)
      
      let rs = GKMersenneTwisterRandomSource()
      rs.seed = UInt64(seedInt!)
      //set up generator with the user's seed for dice values 1-6
      let rd = GKRandomDistribution(randomSource: rs, lowestValue: 1, highestValue: 6)
      
      var numberString = ""
      var printComma : Bool? = false
      
      //generate 1000 numbers and format them in pairs with a comma between each pair
      for _ in 1...1000 {
        let nextNumber = rd.nextInt()
        if printComma == false {
          numberString = numberString + ", " + String(nextNumber)
          printComma = true
        }
        else{
          numberString = numberString + String(nextNumber)
          printComma = false
        }
        
        // add "First 1000 numbers:" text
        if numberString.first == "," {
          numberString.remove(at: numberString.startIndex)
          numberString = "First 1000 numbers:\n\n"  + numberString
        }
      }
      // Put the numbers on the screen
      numbersView.text = numberString
    }
    if numbersView.text.isEmpty {
      numbersView.text = initialText
    }
  }
  
  func  textFieldDidBeginEditing(_ textField: UITextField) {
    textField.autocorrectionType = .no
  }
  func textFieldDidEndEditing(_ textField: UITextField) {
    textField.resignFirstResponder()
    generate1000NumbersFromSeed()
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    // Only allow 0-9 to be entered
    let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
    let compSepByCharInSet = string.components(separatedBy: aSet)
    let numberFilter = compSepByCharInSet.joined(separator: "")
    if numberFilter.isEmpty {
      numbersView.text = initialText
    }
    return string == numberFilter
    
  }
  
  @IBAction func BGBDownload(_ sender: Any) {
    let url = URL(string: "itms-apps://itunes.apple.com/gb/app/bg-buddy-backgammon-scoreboard-clock-and-dice/id972446985?mt=8")!
    
    UIApplication.shared.open(url)
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    // close keyboard
    self.view.endEditing(true)
    return false
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}



