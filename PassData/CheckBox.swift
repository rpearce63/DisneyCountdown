//
//  CheckBox.swift
//  PassData
//
//  Created by Rick on 9/11/16.
//  Copyright © 2016 Pearce. All rights reserved.
//

import Foundation
import UIKit

class CheckBox: UIButton {
    // Images
    let checkedImage = UIImage(named: "cb-on")! as UIImage
    let uncheckedImage = UIImage(named: "cb-off")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, forState: .Normal)
            } else {
                self.setImage(uncheckedImage, forState: .Normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(CheckBox.buttonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.isChecked = false
    }
    
    func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}