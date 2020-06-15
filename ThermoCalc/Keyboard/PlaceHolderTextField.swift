//
//  PlaceHolderTextField.swift
//  ThermoCalc
//
//  Created by 钱晨 on 2020/6/15.
//  Copyright © 2020年 钱晨. All rights reserved.
//

import UIKit

class PlaceHolderTextField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func setup() {
        self.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
        self.text = "CykaBlyat"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
}
