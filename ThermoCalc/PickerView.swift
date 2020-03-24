//
//  PickerView.swift
//  ThermoCalc
//
//  Created by 钱晨 on 2020/3/24.
//  Copyright © 2020年 钱晨. All rights reserved.
//

import UIKit

class PickerView: UIPickerView, UIPickerViewDelegate {
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
    }
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
    }
}
