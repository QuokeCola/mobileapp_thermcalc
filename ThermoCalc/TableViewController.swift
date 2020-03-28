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
    
    var filterResults: [Result] = []
    
    @IBOutlet var PickerViewTextField: UITextField!
    // Interaction of choosing substance
    
    @IBAction func SubstanceClk(_ sender: Any) {
        self.PickerViewTextField.becomeFirstResponder()
    }
    
    var pickerAccessory: UIToolbar?
    
    // COMPONENTS CONFIGURATION
    @objc func cancelBtnClicked(_ button: UIBarButtonItem?) {
        PickerViewTextField?.resignFirstResponder()
    }
    
    /**
     Called when the done button of the `pickerAccessory` was clicked. Dismisses the picker and puts the selected value into the textField
     */
    @objc func doneBtnClicked(_ button: UIBarButtonItem?) {
        PickerViewTextField?.resignFirstResponder()
        ChangeSubstance(substance: SubstancePicker.get_selected_item())
    }
    
    @IBOutlet weak var DeleteButton: UIBarButtonItem!
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
    
    var detailViewController: DetailViewController? = nil
    let searchController = UISearchController(searchResultsController: nil)
    
    var SubstancePicker = PickerView()
    
    override func viewDidLoad() {
        // A data for test.
        Results = [Result(property1: "Hello", property2: "World", calculated_result: calculatedRes(p: "1", v: "1", T: "1", h: "1", u: "1", x: "1", State: "1", Substance: "Water"))]
        for idx in 0...9 {
            Results.append(Result(property1: "\(idx)", property2: "World", calculated_result: calculatedRes(p: "1", v: "1", T: "1", h: "1", u: "1", x: "1", State: "1", Substance: "Water")))
        }
        super.viewDidLoad()
        
        // Picker View Configuration
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(TableViewController.cancelBtnClicked(_:)))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(TableViewController.doneBtnClicked(_:)))
        pickerAccessory = UIToolbar()
        pickerAccessory?.autoresizingMask = .flexibleHeight
        pickerAccessory?.isTranslucent = true
        var frame = pickerAccessory?.frame
        frame?.size.height = 44.0
        pickerAccessory?.frame = frame!
        pickerAccessory?.items = [cancelButton, flexSpace, doneButton]
        PickerViewTextField.inputAccessoryView = pickerAccessory
        
        // Search Substance Configuration
        self.ChangeSubstance(substance: .Water)
        SubstancePicker.initialize()
        PickerViewTextField.inputView = SubstancePicker
        
        // Search Controller configuration
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "ENTER ANY THERMO STATE"
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
        
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if(tableView.contentSize.height<=tableView.bounds.height+100.0  && tableView.contentSize.height>tableView.bounds.height) {
                tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        if segue.identifier == "showDetail" && UIDevice.current.model.contains("iPad") {
//            print("hello")
//            if let indexPath = tableView.indexPathForSelectedRow {
//                let result = Results[indexPath.row]
//                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
//                controller.detailResult = result
//                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
//                controller.navigationItem.leftItemsSupplementBackButton = true
//            }
//        }
//    }
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
    
    
}
extension TableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
    }
}
