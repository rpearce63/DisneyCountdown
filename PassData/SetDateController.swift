//
//  SecondViewController.swift
//  PassData
//
//  Created by Rick on 9/10/16.
//  Copyright © 2016 Pearce. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    
    struct defaultKeys {
        static let eventKey = "eventKey"
        static let dateKey = "dateKey"
        static let parksKey = "parksKey"
        static let cruiseKey = "cruiseKey"
        static let ccLevelKey = "ccLevelKey"
    }

    let defaults = NSUserDefaults.standardUserDefaults()
    
    var selectedDate:NSDate?
    var event:String?
    var ccLevel:String?
    
    
    @IBOutlet weak var chkCruise: CheckBox!
    @IBOutlet weak var chkParks: CheckBox!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var ccView: UIView!
    @IBOutlet weak var ccLevelLabel: UILabel!
    @IBOutlet weak var ccLevelPicker: UIPickerView!
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var selectedDateLabel: UILabel!
    
    let pickerData = ["First Cruise", "Silver", "Gold", "Platinum", "Concierge"]
    let dateFormatter = NSDateFormatter()
    
        override func viewDidLoad() {
        super.viewDidLoad()
        ccLevelPicker.dataSource = self
        ccLevelPicker.delegate = self
        
        datePicker.date = defaults.objectForKey(defaultKeys.dateKey) as! NSDate
        formatDate()
        eventName.text = defaults.stringForKey(defaultKeys.eventKey)
        chkParks.isChecked = defaults.boolForKey(defaultKeys.parksKey)
        chkCruise.isChecked = defaults.boolForKey(defaultKeys.cruiseKey)
        if chkCruise.isChecked {
            ccView.hidden = false
            if let ccLevelValue = defaults.stringForKey(defaultKeys.ccLevelKey){
                //print(ccLevelValue)
                let indexOfSelectedCCLevel = pickerData.indexOf(ccLevelValue)
                //print(indexOfSelectedCCLevel)
                ccLevelPicker.selectRow(indexOfSelectedCCLevel!, inComponent: 0, animated: false)
                ccLevel = ccLevelValue
            }
            
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if saveButton === sender {
            defaults.setValue(eventName.text, forKey: defaultKeys.eventKey)
            defaults.setObject(datePicker.date, forKey: defaultKeys.dateKey)
            defaults.setBool(chkParks.isChecked, forKey: defaultKeys.parksKey)
            defaults.setBool(chkCruise.isChecked, forKey: defaultKeys.cruiseKey)
            if chkCruise.isChecked {
                
                defaults.setValue(pickerData[ccLevelPicker.selectedRowInComponent(0)], forKey: defaultKeys.ccLevelKey)
            }
                        
        }
        
        
    }
    
    func formatDate() {
        dateFormatter.dateStyle = .FullStyle
        selectedDateLabel.text = dateFormatter.stringFromDate(datePicker.date)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        eventName.resignFirstResponder()
        super.touchesBegan(touches, withEvent: event)
    }
    
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    //MARK: Delegates
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //myLabel.text = pickerData[row]
        ccLevel = pickerData[row]
        //print(ccLevel)
        
    }
    @IBAction func cancelClicked(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func parksChecked(sender: AnyObject) {
//        chkParks.setBackgroundImage(UIImage(named: "cb-off"), forState: .Normal)
//        chkParks.setBackgroundImage(UIImage(named: "cb-on"), forState: .Selected)
    }
    
    @IBAction func cruiseChecked(sender: AnyObject) {
//        chkCruise.setBackgroundImage(UIImage(named: "cb-off"), forState: .Normal)
//        chkCruise.setBackgroundImage(UIImage(named: "cb-on"), forState: .Selected)
        ccView.hidden = !ccView.hidden
        
    }
    @IBAction func dateChanged(sender: AnyObject) {
        formatDate()
    }
    

}
