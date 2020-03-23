//
//  TableViewController.swift
//  ThermoCalc
//
//  Created by 钱晨 on 2020/3/21.
//  Copyright © 2020年 钱晨. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController{
    
    var Results = [Result]()
    var detailViewController: DetailViewController? = nil
    
    override func viewDidLoad() {
        Results = [Result(property1: "Hello", property2: "World", calculated_result: Result.calculatedRes(p: "1", v: "1", T: "1", h: "1", u: "1", State: "1"))]
        super.viewDidLoad()
        if let splitViewController = splitViewController {
            let controllers = splitViewController.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        self.navigationItem.searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.hidesSearchBarWhenScrolling = true
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let result = Results[indexPath.row]
        cell.textLabel!.text = result.property1+", "+result.property2
        cell.detailTextLabel!.text = result.calculated_result.get_result()
        return cell
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { (action, actionIndexPath) in
            self.Results.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
        let otherAction = UITableViewRowAction(style: .destructive, title: "OTHER") { (action, actionIndexPath) in
            //其他操作
        }
        return [deleteAction]
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
