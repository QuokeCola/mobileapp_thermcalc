//
//  PickerView.swift
//  ThermoCalc
//
//  Created by 钱晨 on 2020/3/24.
//  Copyright © 2020年 钱晨. All rights reserved.
//

import UIKit

class PickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        self.delegate = self
        self.dataSource = self
        self.reloadAllComponents()
    }
 
    public func get_selected_item()->substance_t{
        switch self.selectedRow(inComponent: 0) {
        case 0:
            return .Water
        case 1:
            return .Ammonia
        case 2:
            return .Propane
        case 3:
            return .Refrigerant_134a
        case 4:
            return .Refrigerant_22
        default:
            return .Water
        }
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch row {
        case 0:
            return "Water"
        case 1:
            return "Ammonia"
        case 2:
            return "Propane"
        case 3:
            return "Refrigerant 134a"
        case 4:
            return "Refrigerant 22"
        default:
            return "Water"
        }
    }
}
