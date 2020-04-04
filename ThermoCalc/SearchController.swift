//
//  SearchController.swift
//  ThermoCalc
//
//  Created by 钱晨 on 2020/4/4.
//  Copyright © 2020年 钱晨. All rights reserved.
//

import UIKit

class SearchController: UISearchController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchResultsUpdater = self
        self.searchBar.placeholder = "ENTER ANY THERMO STATE"
        self.searchBar.delegate = self
        self.obscuresBackgroundDuringPresentation = false
        // Do any additional setup after loading the view.
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
