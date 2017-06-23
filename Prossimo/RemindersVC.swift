//
//  RemindersVC.swift
//  Prossimo
//
//  Created by Rawad Rifai on 6/21/17.
//  Copyright © 2017 Elrifai, Rawad. All rights reserved.
//

import UIKit

class RemindersVC: UIViewController {

    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var txfMessage: UITextView!
    @IBOutlet weak var btn1week: UIButton!
    @IBOutlet weak var btn2weeks: UIButton!
    @IBOutlet weak var btn3weeks: UIButton!
    @IBOutlet weak var btn4weeks: UIButton!
    @IBOutlet weak var btn5weeks: UIButton!
    @IBOutlet weak var btn6weeks: UIButton!
    @IBOutlet weak var txfdays: UITextField!

    
    
    func setBorders() {
        
        mainView.layer.cornerRadius = 10
        mainView.layer.masksToBounds = true
        
        btn1week.layer.cornerRadius = 5
        btn1week.clipsToBounds = true
        btn1week.layer.borderColor = UIColor.blue.cgColor
        btn1week.layer.borderWidth = 1
        
        btn2weeks.layer.cornerRadius = 5
        btn2weeks.clipsToBounds = true
        btn2weeks.layer.borderColor = UIColor.blue.cgColor
        btn2weeks.layer.borderWidth = 1
        
        btn3weeks.layer.cornerRadius = 5
        btn3weeks.clipsToBounds = true
        btn3weeks.layer.borderColor = UIColor.blue.cgColor
        btn3weeks.layer.borderWidth = 1
        
        btn4weeks.layer.cornerRadius = 5
        btn4weeks.clipsToBounds = true
        btn4weeks.layer.borderColor = UIColor.blue.cgColor
        btn4weeks.layer.borderWidth = 1
        
        btn5weeks.layer.cornerRadius = 5
        btn5weeks.clipsToBounds = true
        btn5weeks.layer.borderColor = UIColor.blue.cgColor
        btn5weeks.layer.borderWidth = 1
        
        btn6weeks.layer.cornerRadius = 5
        btn6weeks.clipsToBounds = true
        btn6weeks.layer.borderColor = UIColor.blue.cgColor
        btn6weeks.layer.borderWidth = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setBorders()
        
    
    }

    
    @IBAction func btn1weekClick(_ sender: UIButton) {
    }

    @IBAction func btn2weeksClick(_ sender: UIButton) {
    }
    
    @IBAction func btn3weeksClick(_ sender: UIButton) {
    }
    
    @IBAction func btn4weeksClick(_ sender: UIButton) {
    }
    
    @IBAction func btn5weeksClick(_ sender: UIButton) {
    }
    
    @IBAction func btn6weeksClicks(_ sender: UIButton) {
    }
    
    
    @IBAction func setReminderClick(_ sender: UIButton) {
    }

}
