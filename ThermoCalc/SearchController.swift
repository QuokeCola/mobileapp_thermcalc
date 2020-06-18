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
    
    func manualInitialize() {
        let nib = UINib(nibName: "DecimalKeyboard", bundle: nil)
        let objects = nib.instantiate(withOwner: nil, options: nil)
        decimalKeyboard = objects.first as? DecimalKeyboardView
        
        let keyboardContainerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.5))
        
        keyboardContainerView.addSubview(decimalKeyboard)
        searchTextField = self.searchBar.value(forKey: "_searchField") as? UITextField
        searchTextField!.inputView = keyboardContainerView
        tempTextView = UITextView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0))
        tempTextView.inputView = keyboardContainerView
        self.searchBar.addSubview(tempTextView)
    }
    
    override func viewDidLoad() {
        print("loaded")
        super.viewDidLoad()
        self.searchResultsUpdater = self
        self.searchBar.placeholder = "ENTER ANY THERMO STATE"
        self.searchBar.delegate = self
        self.obscuresBackgroundDuringPresentation = false
        self.searchBar.isExclusiveTouch = true
        searchBar.autocorrectionType = .no
        
        NotificationCenter.default.addObserver(self, selector: #selector(shouldHidePlaceHolderText), name: NSNotification.Name(rawValue: NotificationSearchBarIsEmpty), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleStateKeyPress), name: NSNotification.Name(rawValue: NotificationKeyboardStatePressedKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSubViewClicked), name: NSNotification.Name(NotificationSearchSubViewActivateKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDecimalKeyPressed), name: NSNotification.Name(NotificationKeyboardDecimalPressedKey), object: nil)
        placeHolderView = PlaceHolderView(frame: (searchTextField?.frame)!)
        placeHolderView.frame.size.width -= 28.0
        placeHolderView.frame.origin = CGPoint(x: 28.0, y: 0.0)
        placeHolderView.tag = 1
        searchTextField?.addSubview(placeHolderView)
        let index = self.searchTextField!.subviews.index(of: placeHolderView!)
        searchTextField?.exchangeSubview(at: 0, withSubviewAt: index!)
        // decimalKeyboard.delegate = self
        // Do any additional setup after loading the view
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func shouldHidePlaceHolderText(info: NSNotification) {
        if let placeHolderEmpty = info.object as? Bool {
            if (placeHolderEmpty) {
                searchBar.placeholder = "ENTER ANY THERMO STATE"
                searchTextField?.tintColor = UIColor(red: 49/255, green: 112/255, blue: 228/255, alpha: 0.9)
            } else {
                searchBar.placeholder = ""
                searchTextField?.tintColor = .clear
            }
        }
    }
    
    @objc func handleStateKeyPress(info: NSNotification) {
        if let button = info.object as? KeyboardButton {
            if(button.Key.contains(find: "Delete")) {
                placeHolderView.layer.removeAllAnimations()
                if placeHolderView.placeHolders.count != 0 {
                    placeHolderView.removePlaceHolders(Index: placeHolderView.placeHolders.count - 1)
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
                            if(placeHolderView.placeHolders[selectedIndex+1] is PlaceHolderButton) {
                                placeHolderView.addPlaceHolderTextField(Keyboard: (searchTextField?.inputView)!, Index: selectedIndex+1)
                                placeHolderView.selectComponent(Index: selectedIndex + 1)
                            } else {
                                placeHolderView.selectComponent(Index: selectedIndex + 1)
                            }
                        } else if (selectedIndex == placeHolderView.placeHolders.count - 1) {
                            placeHolderView.addPlaceHolderTextField(Keyboard: (searchTextField?.inputView)!, Index: nil)
                            placeHolderView.selectComponent(Index: selectedIndex + 1)
                        }
                    }
                } else {
                    placeHolderView.addPlaceHolderButton(placeHolderString: titleString, type: .Header)
                    placeHolderView.addPlaceHolderTextField(Keyboard: (searchTextField?.inputView)!,Index: nil)
                    placeHolderView.selectedIndex = placeHolderView.placeHolders.count - 1
                }
            }
        }
    }
    
    @objc func handleDecimalKeyPressed(info: NSNotification) {
        if let button = info.object as? KeyboardButton {
            if let index = placeHolderView.selectedIndex {
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
                        placeHolderView.placeHolders[index] = activeTextField
                        placeHolderView.refreshPlaceHolderView()
                    }
                }
            }
        }
    }
    
    @objc func handleSubViewClicked(info: NSNotification) {
        self.isActive = true
        if info.object is PlaceHolderButton {
            tempTextView.becomeFirstResponder()
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
        return self.isActive && !searchBarIsEmpty()
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
        }
        tempTextView.resignFirstResponder()
    }
}
