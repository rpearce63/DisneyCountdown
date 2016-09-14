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
    
    
    //var rectangleAdView :ADBannerView?
    
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "IMG_0132")!)
        //self.canDisplayBannerAds = true
        // Do any additional setup after loading the view, typically from a nib.
        
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        //rectangleAdView = ADBannerView(adType: ADAdType.MediumRectangle)
        //rectangleAdView?.delegate = self
    
        //dateLabel.text = formatter.stringFromDate(NSDate())
        //eventLabel.text = defaults.stringForKey(defaultsKeys.eventKey)
        
        
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
        
        //print(defaults.stringForKey(defaultsKeys.ccLevelKey))
         
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "pickDate" {
            //let nav = segue.destinationViewController as! UINavigationController
            //nav.interstitialPresentationPolicy =
                //ADInterstitialPresentationPolicy.Automatic
            //let setDateController = nav.topViewController as! SecondViewController
            //setDateController.selectedDate = formatter.dateFromString(dateLabel.text!)
            //setDateController.event = eventLabel.text!
            defaults.setObject(dateLabel.text == nil ? NSDate() : formatter.dateFromString(dateLabel.text!), forKey: defaultsKeys.dateKey)
            defaults.setValue(eventLabel.text, forKey: defaultsKeys.eventKey)
            //defaults.synchronize()
            
        }
    }
    
    
    

    @IBAction func unwindToMainView(sender: UIStoryboardSegue) {
        
        //let sourceViewController = sender.sourceViewController as? SecondViewController
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

        let adrDate = calendar.dateByAddingUnit( [.Day], value: -180, toDate: arrivalDate, options: [] )!
        let fpDate = calendar.dateByAddingUnit( [.Day], value: -60, toDate: arrivalDate, options: [] )!
        if defaults.boolForKey(defaultsKeys.cruiseKey) {
            let checkInDate = calendar.dateByAddingUnit([.Day], value: ccLevelDates[defaults.stringForKey(defaultsKeys.ccLevelKey)!]!, toDate: arrivalDate, options: [])!
            cruiseCheckInView.hidden = false
            cruiseCheckInDate.text = formatter.stringFromDate(checkInDate)
        } else {
            cruiseCheckInView.hidden = true
        }
        
        daysUntilADR.text = formatter.stringFromDate(adrDate)
        daysUntilFP.text = formatter.stringFromDate(fpDate)
        
    }
    
//    func bannerViewDidLoadAd(banner: ADBannerView!) {
//        self.view.addSubview(banner)
//        self.view.layoutIfNeeded()
//    }
//    
//    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError
//        error: NSError!) {
//        banner.removeFromSuperview()
//        self.view.layoutIfNeeded()
//    }

}

