//
//  DetailViewController.swift
//  ThermoCalc
//
//  Created by 钱晨 on 2020/3/23.
//  Copyright © 2020年 钱晨. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var detailResult: Result? {
        didSet {
            configureView()
        }
    }
    
    func configureView() {
        if let DetailResult = self.detailResult {
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return 35.0
        } else {
            return 15.0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0) {
            return "STATE"
        } else if (section == 1) {
            return "PRESSURE"
        } else if (section == 2) {
            return "SPECIFIC VOLUME"
        } else if (section == 3) {
            return "TEMPERATURE"
        } else if (section == 4) {
            return "INTERNAL ENERGY"
        } else if (section == 5){
            return "ENTHALPY"
        } else if (section == 6){
            return "MASS FACTOR X"
        } else {
            return "NULL"
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Property", for: indexPath)
        if(indexPath.section == 0) {
            cell.textLabel!.text = detailResult?.calculated_result.State
        } else if (indexPath.section == 1) {
            cell.textLabel!.text = detailResult?.calculated_result.p
        } else if (indexPath.section == 2) {
            cell.textLabel!.text = detailResult?.calculated_result.v
        } else if (indexPath.section == 3) {
            cell.textLabel!.text = detailResult?.calculated_result.T
        } else if (indexPath.section == 4) {
            cell.textLabel!.text = detailResult?.calculated_result.u
        } else if (indexPath.section == 5) {
            cell.textLabel!.text = detailResult?.calculated_result.h
        } else if (indexPath.section == 6) {
            cell.textLabel!.text = detailResult?.calculated_result.x
        } else {
            cell.textLabel!.text = "NULL"
        }
        return cell
    }
    // CANCEL THE HIGHLIGHT AFTER TOUCHING
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
