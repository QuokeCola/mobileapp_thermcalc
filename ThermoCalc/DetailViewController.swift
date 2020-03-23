//
//  DetailViewController.swift
//  ThermoCalc
//
//  Created by 钱晨 on 2020/3/23.
//  Copyright © 2020年 钱晨. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Property", for: indexPath)
        if(indexPath.row == 0) {
            cell.textLabel!.text = "State:"
            cell.detailTextLabel!.text = detailResult?.calculated_result.State
        } else if (indexPath.row == 1) {
            cell.textLabel!.text = "Pressure:"
            cell.detailTextLabel!.text = detailResult?.calculated_result.p
        } else if (indexPath.row == 2) {
            cell.textLabel!.text = "Specific Volume:"
            cell.detailTextLabel!.text = detailResult?.calculated_result.v
        } else if (indexPath.row == 3) {
            cell.textLabel!.text = "Temperature:"
            cell.detailTextLabel!.text = detailResult?.calculated_result.T
        } else if (indexPath.row == 4) {
            cell.textLabel!.text = "Internal Energy:"
            cell.detailTextLabel!.text = detailResult?.calculated_result.u
        } else if (indexPath.row == 5) {
            cell.textLabel!.text = "Enthalpy:"
            cell.detailTextLabel!.text = detailResult?.calculated_result.h
        }
        return cell
    }
    

    var detailResult: Result? {
        didSet {
            configureView()
        }
    }
    
    func configureView() {
        if let DetailResult = detailResult {
            title = DetailResult.property1+", "+DetailResult.property2
        }
    }
    override func viewDidLoad() {
        configureView()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
