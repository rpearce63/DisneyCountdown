//
//  ViewController.swift
//  PassData
//
//  Created by Rick on 9/10/16.
//  Copyright © 2016 Pearce. All rights reserved.
//

import UIKit
import iAd

class ViewController: UIViewController, ADBannerViewDelegate {
    
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var daysUntil: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var daysUntilADR: UILabel!
    @IBOutlet weak var daysUntilFP: UILabel!
    @IBOutlet weak var cruiseCheckInDate: UILabel!
    @IBOutlet weak var cruiseCheckInView: UIView!
    @IBOutlet weak var parkDatesView: UIView!
    @IBOutlet weak var image: UIImageView!
    
    let formatter = NSDateFormatter()
    
    struct defaultsKeys {
        static let eventKey = "eventKey"
        static let dateKey = "dateKey"
        static let parksKey = "parksKey"
        static let cruiseKey = "cruiseKey"
        static let ccLevelKey = "ccLevelKey"
    }
    
    let defaults = NSUserDefaults.standardUserDefaults()

    let ccLevelDates: [String: Int] = ["First Cruise": -75, "Silver": -90, "Gold": -105, "Platinum": -120, "Concierge": -120]
    
    
    var imageList:[String] = ["castle.png", "IMG_0132.png", "main background.png"]
    let maxImages = 2
    var imageIndex: NSInteger = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        if let stringOne = defaults.stringForKey(defaultsKeys.eventKey) {
            eventLabel.text = stringOne
        }
        
        if let theDate = (defaults.objectForKey(defaultsKeys.dateKey) as? NSDate) {
            dateLabel.text = formatter.stringFromDate(theDate)
            daysUntil.text = daysBetweenDates(NSDate(), endDate: theDate)
            setDaysUntilADRsAndFP(theDate)
        } else {
            dateLabel.text = formatter.stringFromDate(NSDate())
        }
        
        image.userInteractionEnabled = true
        
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swiped(_:))) // put : at the end of method name
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        image.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swiped(_:))) // put : at the end of method name
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        image.addGestureRecognizer(swipeLeft)
        
        image.image = UIImage(named:"castle.png")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "pickDate" {
            defaults.setObject(dateLabel.text == nil ? NSDate() : formatter.dateFromString(dateLabel.text!), forKey: defaultsKeys.dateKey)
            defaults.setValue(eventLabel.text, forKey: defaultsKeys.eventKey)
            
        }
    }
    
    
    

    @IBAction func unwindToMainView(sender: UIStoryboardSegue) {
        
        let selectedDate = defaults.objectForKey(defaultsKeys.dateKey) as? NSDate
        let eventName = defaults.stringForKey(defaultsKeys.eventKey)
        
        dateLabel.text = formatter.stringFromDate(selectedDate!)
        daysUntil.text = daysBetweenDates(NSDate(), endDate: selectedDate!)
        eventLabel.text = eventName
        setDaysUntilADRsAndFP(selectedDate!)
        
        
    }
    
    func daysBetweenDates(startDate: NSDate, endDate: NSDate) -> String
    {
        let calendar = NSCalendar.currentCalendar()
        
        let components = calendar.components([.Month, .Day], fromDate: startDate, toDate: endDate, options: [])
        
        return String("\(components.month) Months, \(components.day) Days")
    }
    
    func setDaysUntilADRsAndFP(arrivalDate: NSDate) {
        let calendar = NSCalendar.currentCalendar()
        if defaults.boolForKey(defaultsKeys.parksKey) {
            let adrDate = calendar.dateByAddingUnit( [.Day], value: -180, toDate: arrivalDate, options: [] )!
            let fpDate = calendar.dateByAddingUnit( [.Day], value: -60, toDate: arrivalDate, options: [] )!
            parkDatesView.hidden = false
            daysUntilADR.text = formatter.stringFromDate(adrDate)
            daysUntilFP.text = formatter.stringFromDate(fpDate)
        } else {
            parkDatesView.hidden = true
        }
        if defaults.boolForKey(defaultsKeys.cruiseKey) {
            let checkInDate = calendar.dateByAddingUnit([.Day], value: ccLevelDates[defaults.stringForKey(defaultsKeys.ccLevelKey)!]!, toDate: arrivalDate, options: [])!
            cruiseCheckInView.hidden = false
            cruiseCheckInDate.text = formatter.stringFromDate(checkInDate)
        } else {
            cruiseCheckInView.hidden = true
        }
    }
    
    func swiped(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizerDirection.Right :
                //print("User swiped right")
                
                // decrease index first
                
                imageIndex -= 1
                
                // check if index is in range
                
                if imageIndex < 0 {
                    
                    imageIndex = maxImages
                    
                }
                
                image.image = UIImage(named: imageList[imageIndex])
                
            case UISwipeGestureRecognizerDirection.Left:
                //print("User swiped Left")
                
                // increase index first
                
                imageIndex += 1
                
                // check if index is in range
                
                if imageIndex > maxImages {
                    
                    imageIndex = 0
                    
                }
                
                image.image = UIImage(named: imageList[imageIndex])
                
                
                
                
            default:
                break //stops the code/codes nothing.
                
                
            }
            
        }
        
        
    }


}

