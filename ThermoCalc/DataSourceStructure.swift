//
//  DataSourceStructure.swift
//  ThermoCalc
//
//  Created by 钱晨 on 2020/3/23.
//  Copyright © 2020年 钱晨. All rights reserved.
//

import Foundation

struct Result{
    let property1: String
    let property2: String
    struct calculatedRes {
        let p: String
        let v: String
        let T: String
        let h: String
        let u: String
        let State: String
        func get_result()->String{
            return "State:\(State), P:\(p), V:\(v), T:\(T), h:\(h), u:\(u)"
        }
    }
    let calculated_result: calculatedRes
}
