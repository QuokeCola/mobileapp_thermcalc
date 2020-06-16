//
//  PlaceHolderView.swift
//  ThermoCalc
//
//  Created by 钱晨 on 2020/6/16.
//  Copyright © 2020年 钱晨. All rights reserved.
//

import UIKit

class PlaceHolderView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var placeHolders = [UIView]()
    var placeHolderHeight = CGFloat(25.0)
    var placeHolderY = CGFloat(0.0)
    var tagUpperBound = 20
    
    func setup() {
        backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
        NotificationCenter.default.addObserver(self, selector: #selector(searchBarSizeChange), name: NSNotification.Name(rawValue: NotificationSearchBarSizeChangeKey), object: nil)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    @objc func searchBarSizeChange(info:NSNotification) {
        if let bounds = info.object as? CGRect {
            let newHeight = max(bounds.height - (52.0 - placeHolderHeight),0.0)
            if placeHolders.count != 0 {
                for i in 0...self.placeHolders.count-1 {
                    if let button = placeHolders[i] as? PlaceHolderButton {
                        button.frame.size = CGSize(width: placeHolders[i].bounds.width, height: newHeight)
                        button.titleLabel?.alpha = max(3.0*newHeight/placeHolderHeight-2.0, 0.0)
                        button.alpha = min(4.0 * newHeight/placeHolderHeight - 1.0, 1.0)
                        placeHolders[i] = button
                    }
                    if let textField = placeHolders[i] as? PlaceHolderTextField {
                        textField.frame.size = CGSize(width: placeHolders[i].bounds.width, height: newHeight)
                        textField.alpha = max(2.0 * newHeight/placeHolderHeight - 1.0, 0.0)
                    }
                }
            }
        }
    }
    
    /**
     For the maxima situation, here should be only four (As two state and two unit).
     */
    func addPlaceHolderButton(placeHolderString: String) {
        placeHolderY = (self.bounds.height - placeHolderHeight)/2.0
        var placeHolderX = CGFloat(0.0)
        for view in placeHolders {
            placeHolderX += view.frame.size.width
        }
        let button = PlaceHolderButton(frame: CGRect(x: placeHolderX, y: placeHolderY, width: 80.0, height: placeHolderHeight))
        button.setTitle(placeHolderString, for: .normal)
        self.placeHolders.append(button)
        self.placeHolders[self.placeHolders.count-1].tag = self.placeHolders.count
        self.addSubview(placeHolders[placeHolders.count-1])
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationSearchBarIsEmpty), object: placeHolders.count == 0)
    }
    
    func addPlaceHolderTextField() {
        placeHolderY = CGFloat(0.0)
        var placeHolderX = CGFloat(0.0)
        for view in placeHolders {
            placeHolderX += view.frame.size.width
        }
        let newTextField = PlaceHolderTextField(frame: CGRect(x: placeHolderX, y: placeHolderY, width: 80.0, height: self.frame.height))
        newTextField.text = ""
        self.placeHolders.append(newTextField)
        self.placeHolders[self.placeHolders.count-1].tag = self.placeHolders.count
        self.addSubview(placeHolders[placeHolders.count-1])
        self.placeHolders[self.placeHolders.count-1].becomeFirstResponder()
    }
    
    func removePlaceHolders(Index: Int) {
        let leftMovement = placeHolders[Index].frame.size.width
        if (Index < self.placeHolders.count - 1) {
            for i in (Index + 1)...self.placeHolders.count-1 {
                self.placeHolders[i].frame.origin.x -= leftMovement
            }
        }
        self.placeHolders[Index].removeFromSuperview()
        self.placeHolders.remove(at: Index)

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationSearchBarIsEmpty), object: placeHolders.count == 0)
    }

    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        guard self.point(inside: point, with: event) else { return nil }
        var finalCandidate: UIView? = nil
        for subview in subviews.reversed() {
            let convertedPoint = subview.convert(point, from: self)
            
            if let candidate = subview.hitTest(convertedPoint, with: event) {
                if let button = subview as? PlaceHolderButton {
                    button.isSelected = true
                    placeHolders[button.tag-1] = button
                    finalCandidate = candidate
                }
                if subview is PlaceHolderTextField {
                    finalCandidate = candidate
                }
            } else {
                if let button = subview as? PlaceHolderButton {
                    button.isSelected = false
                    placeHolders[button.tag-1] = button
                }
            }
        }
        return finalCandidate
    }
    
}
