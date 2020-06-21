//
//  SearchController.swift
//  ThermoCalc
//
//  Created by 钱晨 on 2020/4/4.
//  Copyright © 2020年 钱晨. All rights reserved.
//

import UIKit

class SearchController: UISearchController {
    
    var decimalKeyboard: DecimalKeyboardView!
    var searchTextField: UITextField?
    var inputContent = [String?]()
    var placeHolderView: PlaceHolderView!
    var tempTextView: UITextView!
    var maskView: UIView!
    
    func manualInitialize() {
        let nib = UINib(nibName: "DecimalKeyboard", bundle: nil)
        let objects = nib.instantiate(withOwner: nil, options: nil)
        decimalKeyboard = objects.first as? DecimalKeyboardView
        
        let keyboardContainerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.5))
        
        keyboardContainerView.addSubview(decimalKeyboard)
        searchTextField = self.searchBar.value(forKey: "_searchField") as? UITextField
        searchTextField!.inputView = keyboardContainerView
        searchTextField?.clipsToBounds = true
        tempTextView = UITextView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0))
        tempTextView.inputView = keyboardContainerView
        self.searchBar.placeholder = "ENTER ANY THERMO STATE"
        self.searchBar.addSubview(tempTextView)
    }
    
    override func viewDidLoad() {
        // SearchBar Configuration
        super.viewDidLoad()
        self.searchResultsUpdater = self
        self.searchBar.placeholder = "ENTER ANY THERMO STATE"
        self.searchBar.delegate = self
        self.obscuresBackgroundDuringPresentation = false
        self.searchBar.isExclusiveTouch = true
        self.searchBar.clipsToBounds = true
        self.searchBar.autocorrectionType = .no
        self.searchBar.layer.masksToBounds = true
        
        // Placeholder View configuration
        placeHolderView = PlaceHolderView(frame: (searchTextField?.frame)!)
        placeHolderView.frame.size.width -= 28.0
        placeHolderView.frame.origin = CGPoint(x: 28.0, y: 0.0)
        placeHolderView.tag = 1
        searchTextField?.addSubview(placeHolderView)
        let index = self.searchTextField!.subviews.index(of: placeHolderView!)
        searchTextField?.exchangeSubview(at: 0, withSubviewAt: index!)
        
        // Maskview, for cover the placeholderview when it goes under search icon.
        maskView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 28.0, height: (searchTextField?.frame.height)!))
        maskView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
        maskView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        maskView.layer.cornerRadius = 10.0
        maskView.alpha = 0.0
        searchTextField?.addSubview(maskView)
        UIView.animate(withDuration: 0.5, animations: {self.maskView.alpha = 1.0})
        // decimalKeyboard.delegate = self
        // Do any additional setup after loading the view
        
        // NotificationCenter for Keypress.
        NotificationCenter.default.addObserver(self, selector: #selector(shouldHidePlaceHolderText), name: NSNotification.Name(rawValue: NotificationPlaceHolderIsEmpty), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleStateKeyPress), name: NSNotification.Name(rawValue: NotificationKeyboardStatePressedKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSubViewClicked), name: NSNotification.Name(NotificationSearchSubViewActivateKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDecimalKeyPressed), name: NSNotification.Name(NotificationKeyboardDecimalPressedKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleImagineViewClicked), name: NSNotification.Name(rawValue: NotificationKeyboardImaginePressedKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(searchBarSizeChange), name: NSNotification.Name(rawValue: NotificationSearchBarSizeChangeKey), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // If placeholderView is empty then show the string.
    @objc func shouldHidePlaceHolderText(info: NSNotification) {
        if let placeHolderEmpty = info.object as? Bool {
            if (placeHolderEmpty) {
                searchBar.placeholder = "ENTER ANY THERMO STATE"
                searchTextField?.tintColor = UIColor(red: 49/255, green: 112/255, blue: 228/255, alpha: 0.9)
            } else {
                searchBar.placeholder = ""
                searchTextField?.tintColor = UIColor(red: 49/255, green: 112/255, blue: 228/255, alpha: 0.9)
                searchTextField?.tintColor = .clear
            }
        }
    }
}

// Handle Key input and the action of placeholder view.
extension SearchController {
    @objc func handleStateKeyPress(info: NSNotification) {
        if let button = info.object as? KeyboardButton {
            if(button.Key.contains(find: "Delete")) {
                placeHolderView.layer.removeAllAnimations()
                if placeHolderView.placeHolders.count == 0 {
                    return
                } else {
                    guard let selectedIndex = placeHolderView.selectedIndex else {return}
                    // If it's interview, selected the previous unit buttom
                    if placeHolderView.placeHolders[selectedIndex] is InterView {
                        placeHolderView.selectComponent(Index: selectedIndex-1)
                        return
                    }
                    placeHolderView.removePlaceHolders(Index: selectedIndex)
                    if placeHolderView.placeHolders.count != 0 {
                        placeHolderView.selectComponent(Index: max(selectedIndex-1,0))
                    } else {
                        placeHolderView.selectComponent(Index: nil)
                    }
                }
                
            } else {
                var titleString = ""
                switch button.Key {
                case "Pressure":
                    titleString = "p:"
                case "Spc.Vol":
                    titleString = "v:"
                case "Temp":
                    titleString = "T:"
                case "Int.Engy":
                    titleString = "u:"
                case "Enthalpy":
                    titleString = "h:"
                case "MassFac":
                    titleString = "x:"
                case "Entropy":
                    titleString = "s:"
                default:
                    titleString = " "
                }
                if let selectedIndex = placeHolderView.selectedIndex {
                    if let view = placeHolderView.placeHolders[selectedIndex] as? PlaceHolderButton {
                        view.setTitle(titleString, for: .normal)
                        if(selectedIndex <= placeHolderView.placeHolders.count - 2) {
                            if(placeHolderView.placeHolders[selectedIndex+1] is PlaceHolderButton || placeHolderView.placeHolders[selectedIndex+1] is InterView) {
                                placeHolderView.addPlaceHolderTextField(Keyboard: (searchTextField?.inputView)!, Index: selectedIndex+1)
                                placeHolderView.selectComponent(Index: selectedIndex + 1)
                            } else {
                                placeHolderView.selectComponent(Index: selectedIndex + 1)
                            }
                        } else if (selectedIndex == placeHolderView.placeHolders.count - 1) {
                            placeHolderView.addPlaceHolderTextField(Keyboard: (searchTextField?.inputView)!, Index: nil)
                            placeHolderView.selectComponent(Index: selectedIndex + 1)
                            return
                        }
                    } else if placeHolderView.placeHolders[selectedIndex] is InterView {
                        if selectedIndex < placeHolderView.placeHolders.count - 1 {
                            if let nextItem = placeHolderView.placeHolders[selectedIndex+1] as? PlaceHolderButton {
                                if nextItem.placeHolderButtonType == .Unit {
                                    placeHolderView.addPlaceHolderButton(placeHolderString: titleString, type: .Header, index: nil)
                                    placeHolderView.addPlaceHolderTextField(Keyboard: (searchTextField?.inputView)!,Index: nil)
                                    placeHolderView.selectComponent(Index: selectedIndex + 2)
                                } else {
                                    nextItem.layer.removeAllAnimations()
                                    for nextItemSubview in nextItem.subviews {
                                        nextItemSubview.layer.removeAllAnimations()
                                    }
                                    nextItem.alpha = 1.0
                                    nextItem.setTitle(titleString, for: .normal)
                                    if selectedIndex < placeHolderView.placeHolders.count - 2{
                                        if placeHolderView.placeHolders[selectedIndex + 2] is PlaceHolderTextField {
                                            placeHolderView.selectComponent(Index: selectedIndex+2)
                                            return
                                        } else {
                                            placeHolderView.addPlaceHolderTextField(Keyboard: (searchTextField?.inputView)!, Index: selectedIndex + 2)
                                            placeHolderView.selectComponent(Index: selectedIndex+2)
                                        }
                                    }
                                }
                            } else {
                                if placeHolderView.placeHolders[selectedIndex+1] is PlaceHolderTextField {
                                    placeHolderView.addPlaceHolderButton(placeHolderString: titleString, type: .Header, index: selectedIndex + 1)
                                }
                            }
                        } else {
                            placeHolderView.addPlaceHolderButton(placeHolderString: titleString, type: .Header, index: nil)
                            placeHolderView.addPlaceHolderTextField(Keyboard: (searchTextField?.inputView)!,Index: nil)
                            placeHolderView.selectComponent(Index: placeHolderView.placeHolders.count - 1)
                        }
                    }
                } else {
                    placeHolderView.addPlaceHolderButton(placeHolderString: titleString, type: .Header, index: nil)
                    placeHolderView.addPlaceHolderTextField(Keyboard: (searchTextField?.inputView)!,Index: nil)
                    placeHolderView.selectComponent(Index: placeHolderView.placeHolders.count - 1)
                }
            }
        }
    }
    
    @objc func handleDecimalKeyPressed(info: NSNotification) {
        if let button = info.object as? KeyboardButton {
            if let index = placeHolderView.selectedIndex {
                if index >= placeHolderView.placeHolders.count {
                    return
                }
                if let activeTextField = placeHolderView.placeHolders[index] as? PlaceHolderTextField {
                    if(button.Key.contains(find: "Delete")) {
                        if(activeTextField.text == "") {
                            placeHolderView.removePlaceHolders(Index: index)
                            placeHolderView.selectComponent(Index: max(index-1,0))
                        } else {
                            activeTextField.deleteBackward()
                            placeHolderView.placeHolders[index] = activeTextField
                            placeHolderView.refreshPlaceHolderView()
                        }
                    } else {
                        activeTextField.insertText(button.Key)
                        placeHolderView.refreshPlaceHolderView()
                    }
                } else if let currentbutton = placeHolderView.placeHolders[index] as? PlaceHolderButton {
                    if(button.Key.contains(find: "Delete") && currentbutton.placeHolderButtonType == .Unit){
                        if index < placeHolderView.placeHolders.count - 1{
                            placeHolderView.removePlaceHolders(Index: index+1)
                        }
                        placeHolderView.removePlaceHolders(Index: index)
                        placeHolderView.selectComponent(Index: index - 1)
                    } else {
                        if index > 0 {
                            if placeHolderView.placeHolders[index - 1] is PlaceHolderTextField {
                                placeHolderView.selectComponent(Index: index - 1)
                            } else {
                                placeHolderView.addPlaceHolderTextField(Keyboard: (searchTextField?.inputView)!, Index: index)
                                placeHolderView.selectComponent(Index: index)
                            }
                            guard let selectedIndex = placeHolderView.selectedIndex else {return}
                            if let textfield = placeHolderView.placeHolders[selectedIndex] as? PlaceHolderTextField {
                                textfield.insertText(button.Key)
                            }
                        } else {
                            placeHolderView.addPlaceHolderTextField(Keyboard: (searchTextField?.inputView)!, Index: 0)
                            placeHolderView.selectComponent(Index: 0)
                            let textfield = placeHolderView.placeHolders[0] as! PlaceHolderTextField
                            textfield.insertText(button.Key)
                        }
                    }
                }
            }
        }
    }
    
    @objc func handleSubViewClicked(info: NSNotification) {
        if info.object is PlaceHolderButton {
            self.isActive = true
            self.searchBar.resignFirstResponder()
            tempTextView.becomeFirstResponder()
        } else if info.object is UITextField {
            if !(info.object is PlaceHolderTextField) && placeHolderView.placeHolders.count != 0 {
                self.isActive = true
                self.searchBar.resignFirstResponder()
                placeHolderView.selectComponent(Index: placeHolderView.placeHolders.count - 1)
                if placeHolderView.placeHolders[placeHolderView.placeHolders.count - 1] is PlaceHolderButton {
                    self.searchBar.resignFirstResponder()
                    tempTextView.becomeFirstResponder()
                }
            } else if !(info.object is PlaceHolderTextField) && placeHolderView.placeHolders.count == 0{
                self.searchBar.becomeFirstResponder()
                self.isActive = true
            } else if let textfield = info.object as? PlaceHolderTextField {
                self.isActive = true
                self.searchBar.resignFirstResponder()
                _ = textfield.becomeFirstResponder()
            }
        } else if info.object is InterView {
            let view = info.object as! InterView
            self.searchBar.becomeFirstResponder()
            self.isActive = true
            placeHolderView.selectComponent(Index: view.tag - 1)
        }
    }
    
    @objc func handleImagineViewClicked(info: NSNotification) {
        if let button = info.object as? ImagineButton {
            if placeHolderView.placeHolders[placeHolderView.selectedIndex!] is PlaceHolderTextField {
                if placeHolderView.selectedIndex! == placeHolderView.placeHolders.count-1 {
                    placeHolderView.addPlaceHolderButton(placeHolderString: (button.titleLabel?.text)!, type: .Unit, index: nil)
                    var containsInterView = false
                    for view in placeHolderView.placeHolders {
                        if view.tag == self.placeHolderView.placeHolders[placeHolderView.selectedIndex!].tag {
                            break
                        }
                        if view is InterView {
                            containsInterView = true
                        }
                    }
                    if !containsInterView {
                        placeHolderView.addInterView(Keyboard: (searchTextField?.inputView)!, index: nil)
                    }
                    placeHolderView.selectComponent(Index: placeHolderView.placeHolders.count - 1)
                } else {
                    if let nextButton = placeHolderView.placeHolders[placeHolderView.selectedIndex!+1] as? PlaceHolderButton {
                        if nextButton.placeHolderButtonType == .Unit {
                            nextButton.setTitle((button.titleLabel?.text)!, for: .normal)
                            var containsInterView = false
                            for placeHolder in placeHolderView.placeHolders {
                                if view.tag == placeHolderView.placeHolders[placeHolderView.selectedIndex!+1].tag {
                                    break
                                }
                                if placeHolder is InterView {
                                    containsInterView = true
                                }
                            }
                            if !(containsInterView) {
                                if placeHolderView.selectedIndex! + 2 < placeHolderView.placeHolders.count {
                                    if placeHolderView.placeHolders[placeHolderView.selectedIndex! + 2] is InterView {
                                        placeHolderView.selectComponent(Index: placeHolderView.selectedIndex! + 2)
                                        return
                                    } else {
                                        placeHolderView.addInterView(Keyboard: (searchTextField?.inputView)!, index: placeHolderView.selectedIndex! + 2)
                                        placeHolderView.selectComponent(Index: placeHolderView.selectedIndex! + 2)
                                    }
                                } else {
                                    placeHolderView.addInterView(Keyboard: (searchTextField?.inputView)!, index: nil)
                                    placeHolderView.selectComponent(Index: placeHolderView.selectedIndex! + 2)
                                }
                            }
                        } else if nextButton.placeHolderButtonType == .Header {
                            placeHolderView.addPlaceHolderButton(placeHolderString: (button.titleLabel?.text)!, type: .Unit, index: placeHolderView.selectedIndex! + 1)
                            var containsInterView = false
                            for view in placeHolderView.placeHolders {
                                if view.tag == placeHolderView.placeHolders[placeHolderView.selectedIndex!+1].tag {
                                    break
                                }
                                if view is InterView {
                                    containsInterView = true
                                }
                            }
                            if !(containsInterView) {
                                if placeHolderView.selectedIndex! + 2 < placeHolderView.placeHolders.count {
                                    if placeHolderView.placeHolders[placeHolderView.selectedIndex! + 2] is InterView {
                                        placeHolderView.selectComponent(Index: placeHolderView.selectedIndex! + 2)
                                        return
                                    } else {
                                        placeHolderView.addInterView(Keyboard: (searchTextField?.inputView)!, index: placeHolderView.selectedIndex! + 2)
                                        placeHolderView.selectComponent(Index: placeHolderView.selectedIndex! + 2)
                                    }
                                } else {
                                    placeHolderView.addInterView(Keyboard: (searchTextField?.inputView)!, index: nil)
                                    placeHolderView.selectComponent(Index: placeHolderView.selectedIndex! + 2)
                                }
                            }
                        }
                        
                    }
                }
            } else if let currentButton = placeHolderView.placeHolders[placeHolderView.selectedIndex!] as? PlaceHolderButton {
                currentButton.setTitle((button.titleLabel?.text)!, for: .normal)
                var containsInterView = false
                for view in placeHolderView.placeHolders {
                    if view is InterView {
                        containsInterView = true
                    }
                    if view.tag == currentButton.tag+1 {
                        break
                    }
                }
                if !(containsInterView) {
                    if placeHolderView.selectedIndex! < placeHolderView.placeHolders.count-2 {
                        if placeHolderView.placeHolders[placeHolderView.selectedIndex! + 2] is InterView {
                            placeHolderView.selectComponent(Index: placeHolderView.selectedIndex! + 2)
                            return
                        } else {
                            placeHolderView.addInterView(Keyboard: (searchTextField?.inputView)!, index: placeHolderView.selectedIndex! + 2)
                            placeHolderView.selectComponent(Index: placeHolderView.selectedIndex! + 2)
                        }
                    } else {
                        placeHolderView.addInterView(Keyboard: (searchTextField?.inputView)!, index: nil)
                        placeHolderView.selectComponent(Index: placeHolderView.placeHolders.count - 1)
                    }
                }
            }
        }

        
    }
}

extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
        NotificationCenter.default.post(name: NSNotification.Name(NotificationSearchBarInputKey), object: self)
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return self.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        searchFilterResults = Results.filter({(result:searchAttempt) -> Bool in
            let splitedText = searchText.split(separator: ",")
            for subString in splitedText {
                if (subString == "") {
                    continue
                }
                if (!result.calculated_result.get_result().lowercased().contains(String(subString).trimmingCharacters(in: .whitespaces).lowercased())) {
                    return false
                }
            }
            return true
        })
    }
    
    func isFiltering() -> Bool {
        return self.isActive && (placeHolderView.placeHolders.count != 0)
    }
}

extension SearchController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Event Recieved.")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationSearchBarSearchKey), object: self)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        for subview in self.placeHolderView.subviews {
            subview.resignFirstResponder()
            if let itv = subview as? InterView {
                for subitv in itv.subviews {
                    subitv.resignFirstResponder()
                }
            }
        }
        tempTextView.resignFirstResponder()
    }
    
    @objc func searchBarSizeChange(info:NSNotification) {
        maskView.frame.size.height = searchTextField!.bounds.height
    }
    
}
