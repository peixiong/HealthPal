//
//  SuggestionBubbleViewController.swift
//  HealthAssistant
//
//  Created by Pei Xiong on 5/2/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

import UIKit
import WobbleBubbleButton

class SuggestionBubbleViewController: UIViewController, PopUPButtonDelegate {
    var user:User?
    var concern = ""
    var sortWay = ""
    var selectedFpId = 0
    var buttonsArray = NSMutableArray()
    var backgroundView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onConcernButtonPressed(sender: WobbleBubbleButton) {
        if sender.tag == 5 {
            self.concern = "nf_calories"
        } else if sender.tag == 12 {
            self.concern = "nf_calcium_dv"
        } else if sender.tag == 7 {
            self.concern = "nf_protein"
        }else if sender.tag == 13 {
            self.concern = "nf_iron_dv"
        }else if sender.tag == 8 {
            self.concern = "nf_total_fat"
        }else if sender.tag == 9 {
            self.concern = "nf_sugars"
        }else if sender.tag == 6 {
            self.concern = "nf_total_carbohydrate"
        }else if sender.tag == 10 {
            self.concern = "nf_dietary_fiber"
        }else if sender.tag == 14 {
            self.concern = "nf_vitamin_a_dv"
        }else if sender.tag == 11 {
            self.concern = "nf_sodium"
        }else if sender.tag == 15 {
            self.concern = "nf_vitamin_c_dv"
        }
        self.selectedFpId = sender.tag
        self.generateBackgroundViewWithTapGestureRecognizer()
        self.generatePopUpButtons()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let dvc = segue.destinationViewController as! FoodListTableViewController
        dvc.concern = self.concern
        dvc.sortWay = self.sortWay
        dvc.selectedFpId = self.selectedFpId
        dvc.user = self.user
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: self, action: nil)
    }
    
    func generateBackgroundViewWithTapGestureRecognizer(){
        self.backgroundView = UIImageView(frame: self.view.frame)
        self.backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        self.view.addSubview(self.backgroundView)
        self.backgroundView.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(SuggestionBubbleViewController.popDownButtons))
        self.backgroundView.addGestureRecognizer(tap)
    }

    
    func generatePopUpButtons() {
        //self.generateBackgroundViewWithTapGestureRecognizer()
        let vW = self.view.frame.size.width
        let buttonTitles = ["Want more?", "Want less?"]
        let buttonBackgroundColors = [UIColor.brownColor(), UIColor.purpleColor()]
        for i in 0...1 {
            let button = PopUPButton(frame: CGRectMake(0.35*vW, 0.3*vW*CGFloat(i), 0.3*vW, 0.3*vW), title: buttonTitles[i], destinationFrame: CGRectMake(0.35*vW, 100+0.3*vW*CGFloat(i) + 30, 0.3*vW, 0.3*vW), tag: i) as PopUPButton
            button.backgroundColor = buttonBackgroundColors[i]
            button.tag = i
            button.layer.cornerRadius = 0.35*vW/5
            self.view.addSubview(button)
            self.buttonsArray.addObject(button)
            button.delegate = self
        }
    }
    
    func popDownButtons() {
        self.backgroundView.removeFromSuperview()
        let button0 = self.buttonsArray[0] as! PopUPButton
        let button1 = self.buttonsArray[1] as! PopUPButton
        button0.removeFromSuperview()
        button1.removeFromSuperview()
        self.buttonsArray = NSMutableArray()

    }

    func buttonSelected(button: UIButton!) {
        self.popDownButtons()
        if button.tag == 0 {
            self.sortWay = "desc"
        } else {
            self.sortWay = "asc"
        }
        performSegueWithIdentifier("suggestion", sender: self)
    }
}
