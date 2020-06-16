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
    
    func manualInitialize() {
        let nib = UINib(nibName: "DecimalKeyboard", bundle: nil)
        let objects = nib.instantiate(withOwner: nil, options: nil)
        decimalKeyboard = objects.first as? DecimalKeyboardView
        
        let keyboardContainerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.5))
        
        keyboardContainerView.addSubview(decimalKeyboard)
        searchTextField = self.searchBar.value(forKey: "_searchField") as? UITextField
        searchTextField!.inputView = keyboardContainerView
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
        
        placeHolderView = PlaceHolderView(frame: (searchTextField?.frame)!)
        placeHolderView.frame.size.width -= 28.0
        placeHolderView.frame.origin = CGPoint(x: 28.0, y: 0.0)
        placeHolderView.tag = 1
        searchTextField?.addSubview(placeHolderView)
        let index = self.searchTextField!.subviews.index(of: placeHolderView!)
        searchTextField?.exchangeSubview(at: 0, withSubviewAt: index!)
        // decimalKeyboard.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func shouldHidePlaceHolderText(info: NSNotification) {
        if let placeHolderEmpty = info.object as? Bool {
            if (placeHolderEmpty) {
                searchBar.placeholder = "ENTER ANY THERMO STATE"
            } else {
                searchBar.placeholder = ""
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
                placeHolderView.addPlaceHolderButton(placeHolderString: titleString)
            }
        }
    }
    // When Searchbar Collapse, placeholders disappear.
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
        searchFilterResults = Results.filter({(result:Result) -> Bool in
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
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        for subView in (searchTextField?.subviews)! {
            subView.resignFirstResponder()
        }
    }
}

extension SearchController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Event Recieved.")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationSearchBarSearchKey), object: self)
    }
}
