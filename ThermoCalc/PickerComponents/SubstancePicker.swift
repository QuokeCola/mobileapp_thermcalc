//
//  SubstancePicker.swift
//  ThermoCalc
//
//  Created by 钱晨 on 2020/4/4.
//  Copyright © 2020年 钱晨. All rights reserved.
//

import UIKit

class SubstancePicker: UITextField {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    var pickerAccessory: UIToolbar?
    var substancePicker = PickerView()
    override func draw(_ rect: CGRect) {
        // Drawing code
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.PickerCancelClk(_:)))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.PickerDoneClk(_:)))
        pickerAccessory = UIToolbar()
        pickerAccessory?.autoresizingMask = .flexibleHeight
        pickerAccessory?.isTranslucent = true
        var frame = pickerAccessory?.frame
        frame?.size.height = 44.0
        pickerAccessory?.frame = frame!
        pickerAccessory?.items = [cancelButton, flexSpace, doneButton]
        
        self.inputAccessoryView = self.pickerAccessory
        self.inputView = self.substancePicker
    }
    
    @objc func PickerCancelClk(_ button: UIBarButtonItem?) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationPickerViewCancelKey), object: self)
    }
    
    @objc func PickerDoneClk(_ button: UIBarButtonItem?) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationPickerViewDoneKey), object: self)
    }
    
    func get_selected_item()->substance_t {
        return substancePicker.get_selected_item()
    }
}
