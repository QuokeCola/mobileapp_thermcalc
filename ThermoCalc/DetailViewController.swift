//
//  DetailViewController.swift
//  ThermoCalc
//
//  Created by 钱晨 on 2020/3/23.
//  Copyright © 2020年 钱晨. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
