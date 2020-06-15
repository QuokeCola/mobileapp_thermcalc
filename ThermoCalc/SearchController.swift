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
    var placeHolderButtons = [PlaceHolderButton]()
    var placeHolderTextFields = [PlaceHolderTextField]()
    var placeHolderHeight = CGFloat(25.0)
    var placeHolderY = CGFloat(0.0)
    var searchTextField: UITextField?
    
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
        super.viewDidLoad()
        print("ViewLoaded")
        self.searchResultsUpdater = self
        self.searchBar.placeholder = "ENTER ANY THERMO STATE"
        self.searchBar.delegate = self
        self.obscuresBackgroundDuringPresentation = false
        self.searchBar.isExclusiveTouch = true

        NotificationCenter.default.addObserver(self, selector: #selector(searchBarSizeChange), name: NSNotification.Name(rawValue: NotificationSearchBarSizeChangeKey), object: nil)
        
        searchBar.autocorrectionType = .no
        
        // decimalKeyboard.delegate = self
        // Do any additional setup after loading the view.
        
    }
    
    // When Searchbar Collapse, placeholders disappear.
    
    @objc func searchBarSizeChange(info:NSNotification) {
        if placeHolderButtons.count == 0 {
            return
        }
        if let bounds = info.object as? CGRect {
            let newHeight = max(bounds.height - (52.0 - placeHolderHeight),0.0)
            for i in 0...self.placeHolderButtons.count-1 {
                self.placeHolderButtons[i].frame.size = CGSize(width: placeHolderButtons[i].bounds.width, height: newHeight)
                self.placeHolderButtons[i].titleLabel?.alpha = max(3.0*newHeight/placeHolderHeight-2.0, 0.0)
                self.placeHolderButtons[i].alpha = min(4.0 * newHeight/placeHolderHeight - 1.0, 1.0)
            }
        }
    }
    
    /**
     For the maxima situation, here should be only four (As two state and two unit).
     */
    func addPlaceHolderButton(placeHolderString: String, LocX: CGFloat) {
        placeHolderY = (searchTextField!.bounds.height - placeHolderHeight)/2.0
        let button = PlaceHolderButton(frame: CGRect(x: LocX, y: placeHolderY, width: 80.0, height: placeHolderHeight))
        button.setTitle(placeHolderString, for: .normal)
        button.addTarget(self, action: #selector(touchButton(sender:)), for: .touchUpInside)
        self.placeHolderButtons.append(button)
        self.placeHolderButtons[self.placeHolderButtons.count-1].tag = self.placeHolderButtons.count
        self.searchTextField?.addSubview(placeHolderButtons[placeHolderButtons.count-1])
        if(placeHolderButtons.count != 0) {
            searchBar.placeholder = ""
        } else {
            searchBar.placeholder = "ENTER ANY THERMO STATE"
        }
    }
    
    /**
     Start from 1, as 0 is for the textfield.
     If move 0, the textfield will be moved and there's no input view.
     */
    func removePlaceHolderButton(placeHolderTag: Int) {
        if let removeButton = searchTextField?.viewWithTag(placeHolderTag) {
            removeButton.removeFromSuperview()
            placeHolderButtons.remove(at: placeHolderTag-1)
        }
        if(placeHolderButtons.count != 0) {
            searchBar.placeholder = ""
        } else {
            searchBar.placeholder = "ENTER ANY THERMO STATE"
        }
    }
    
    @objc func touchButton(sender: PlaceHolderButton) {
        if sender.isSelected {
            sender.deselectButton()
        } else {
            sender.selectButton()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
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
}

extension SearchController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Event Recieved.")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationSearchBarSearchKey), object: self)
    }
}
