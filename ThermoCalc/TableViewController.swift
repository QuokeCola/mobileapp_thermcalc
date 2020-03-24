//
//  TableViewController.swift
//  ThermoCalc
//
//  Created by 钱晨 on 2020/3/21.
//  Copyright © 2020年 钱晨. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController{
    
    enum substance_t {
        case Water
        case Refrigerant_22
        case Refrigerant_134a
        case Ammonia
        case Propane
    }
    func ChangeSubstance(substance: substance_t) {
        Substance = substance
        var MainViewTitle: String = ""
        
        switch Substance {
        case .Water:
            MainViewTitle = "Water"
        case .Ammonia:
            MainViewTitle = "Ammonia"
        case .Propane:
            MainViewTitle = "Propane"
        case .Refrigerant_134a:
            MainViewTitle = "Refrigerant 134a"
        case .Refrigerant_22:
            MainViewTitle = "Refrigerant 22"
        default:
            title = "Water"
        }
        self.title = MainViewTitle
    }
    
    var Substance: substance_t = .Water
    var Results = [Result]()
    var filterResults: [Result] = []
    
    // Interaction of choosing substance
    @IBAction func SubstanceClk(_ sender: Any) {
        self.PickerViewTextField.becomeFirstResponder()
    }
    
    // COMPONENTS CONFIGURATION
    var detailViewController: DetailViewController? = nil
    let searchController = UISearchController(searchResultsController: nil)
    var PickerViewTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    override func viewDidLoad() {
        // A data for test.
        Results = [Result(property1: "Hello", property2: "World", calculated_result: calculatedRes(p: "1", v: "1", T: "1", h: "1", u: "1", State: "1", Substance: "Water"))]
        super.viewDidLoad()
        // Search Condition Configuration
        self.ChangeSubstance(substance: .Water)
        //self.PickerViewTextField.inputView
        
        // Search controller configuration
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "ENTER ANY THERMO STATE"
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
        
        if let splitViewController = splitViewController {
            let controllers = splitViewController.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    // ONLY ONE SECTION
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    // GET CELL COUNT
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Results.count
    }
    // GET CELL
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let result = Results[indexPath.row]
        cell.textLabel!.text = result.calculated_result.Substance+": "+result.property1+", "+result.property2
        cell.detailTextLabel!.text = result.calculated_result.get_result()
        return cell
    }
    // DELETE ACTION
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { (action, actionIndexPath) in
            self.Results.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
        return [deleteAction]
    }
    // CANCEL THE HIGHLIGHT AFTER TOUCHING
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let result = Results[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailResult = result
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
}
extension TableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
    }
}
