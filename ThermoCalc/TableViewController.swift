//
//  TableViewController.swift
//  ThermoCalc
//
//  Created by 钱晨 on 2020/3/21.
//  Copyright © 2020年 钱晨. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
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
        }
        self.title = MainViewTitle
    }
    
    var Substance: substance_t = .Water
    
    @IBOutlet var PickerViewTextField: SubstancePicker!
    // Interaction of choosing substance
    
    @IBAction func SubstanceClk(_ sender: Any) {
        self.PickerViewTextField.becomeFirstResponder()
    }
    
    /**
     Called when the cancel button of the `pickerAccessory` was clicked. Dismisses the picker. The call is implemented in the SubstancePicker (A textfield) and using notification center to call this function.
     */
    @objc func cancelBtnClicked(_ button: UIBarButtonItem?) {
        PickerViewTextField?.resignFirstResponder()
    }
    
    /**
     Called when the done button of the `pickerAccessory` was clicked. Dismisses the picker and puts the selected value into the textField. The call is implemented in the SubstancePicker (A textfield) and using notification center to call this function.
     */
    @objc func doneBtnClicked(_ button: UIBarButtonItem?) {
        PickerViewTextField?.resignFirstResponder()
        ChangeSubstance(substance: PickerViewTextField.get_selected_item())
    }
    
    // Delete all records
    @IBAction func deleteButtonClk(_ sender: Any) {
        let alertController = UIAlertController(title: "YOU WILL DELETE ALL RECORDS", message: "IT WILL NOT BE INVERTIBLE", preferredStyle: UIAlertControllerStyle.actionSheet)
        let cancelAction = UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "DELETE", style: UIAlertActionStyle.destructive, handler: deleteButtonConfirmed)
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        if(UIDevice.current.model.contains("iPad")) {
            alertController.popoverPresentationController?.sourceView = splitViewController?.view;
            alertController.popoverPresentationController?.sourceRect = CGRect(x: tableView.bounds.width-27, y: 0, width: 0, height: 60)
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func deleteButtonConfirmed(_ sender: UIAlertAction) {
        Results.removeAll()
        self.tableView.reloadData()
    }
    
    // COMPONENTS CONFIGURATION
    var detailViewController: DetailViewController? = nil
    let searchController = SearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        // A data for test.
        Results = [Result(property1: "Hello", property2: "World", calculated_result: calculatedRes(p: "1", v: "1", T: "1", h: "1", u: "1", x: "1", State: "1", Substance: "Water"))]
        for idx in 0...9 {
            Results.append(Result(property1: "\(idx)", property2: "World", calculated_result: calculatedRes(p: "\(idx)", v: "1", T: "1", h: "1", u: "1", x: "1", State: "1", Substance: "Water")))
        }
        super.viewDidLoad()
        
        // Picker View Configuration
        NotificationCenter.default.addObserver(self, selector: #selector(self.cancelBtnClicked), name: NSNotification.Name(rawValue: NotificationPickerViewCancelKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.doneBtnClicked), name: NSNotification.Name(rawValue: NotificationPickerViewDoneKey), object: nil)
        
        // Search Substance Picker Configuration
        self.ChangeSubstance(substance: .Water)

        
        // Search Controller configuration
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTableView), name: NSNotification.Name(rawValue: NotificationSearchBarInputKey), object: nil)
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
        
        // Search Imagin Configuration
        // Splitview Controller configuration
        if let splitViewController = splitViewController {
            let controllers = splitViewController.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        
        // 3D touch
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: tableView)
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
        if(isFiltering()) {
            return 2
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(isFiltering()) {
            if (section == 0){
                return "CALCULATING RESULT"
            } else {
                return "EXIST RESULTS"
            }
        } else {
            return ""
        }
    }
    
    // GET CELL COUNT
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(isFiltering()) {
            if(section == 0) {
                return 1
            } else {
                return searchFilterResults.count
            }
        } else {
            return Results.count
        }
    }
    
    // GET CELL
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if(searchController.isFiltering()) {
            if(indexPath.section == 0) {
                cell.textLabel!.text = searchController.searchBar.text
                cell.detailTextLabel?.text = "Searching..."// TODO: add calculated Results.
            } else {
                let result = searchFilterResults[indexPath.row]
                cell.textLabel!.text = result.calculated_result.Substance+": "+result.property1+", "+result.property2
                cell.detailTextLabel!.text = result.calculated_result.get_result()
            }
        } else {
            let result = Results[indexPath.row]
            cell.textLabel!.text = result.calculated_result.Substance+": "+result.property1+", "+result.property2
            cell.detailTextLabel!.text = result.calculated_result.get_result()
            
        }
        return cell
    }
    
    // DELETE ACTION
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // HIDE the glitch by deleting rows.
            if(tableView.contentSize.height<=tableView.bounds.height+100.0  && tableView.contentSize.height>tableView.bounds.height-100.0) {
                DispatchQueue.main.async {
                    tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                }
            }
            Results.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    // CANCEL THE HIGHLIGHT AFTER TOUCHING
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if(Results.count != 0) {
            let result = Results[indexPath.row]
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "DetailView") as! DetailViewController
            controller.detailResult = result
            controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
            if(!UIDevice.current.model.contains("iPad")) {
                show(controller, sender: self)
            } else {
                let navcontroller = splitViewController?.viewControllers[(splitViewController?.viewControllers.count)!-1] as! UINavigationController
                navcontroller.viewControllers[0] = controller
                splitViewController?.viewControllers[(splitViewController?.viewControllers.count)!-1] = navcontroller
            }
        }
    }
    
    @objc func updateTableView() {
        self.tableView.reloadData()
    }
}
// 3D touch
extension TableViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard
            let indexPath = tableView.indexPathForRow(at: location),
            let cell = tableView.cellForRow(at: indexPath)
            else {
                return nil
        }
        previewingContext.sourceRect = cell.frame
        let result = Results[indexPath.row]
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "DetailView") as! DetailViewController
        controller.detailResult = result
        controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        controller.navigationItem.leftItemsSupplementBackButton = true
        return controller
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
    func isFiltering()->Bool{
        return self.searchController.isFiltering()
    }
}
