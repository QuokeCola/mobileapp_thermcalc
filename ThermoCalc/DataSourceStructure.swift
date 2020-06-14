//
//  DataSourceStructure.swift
//  ThermoCalc
//
//  Created by 钱晨 on 2020/3/23.
//  Copyright © 2020年 钱晨. All rights reserved.
//

import Foundation

struct calculatedRes {
    let p: String
    let v: String
    let T: String
    let h: String
    let u: String
    let x: String
    let State: String
    let Substance: String
    func get_result()->String{
        return "State:\(State), P:\(p), V:\(v), T:\(T), h:\(h), u:\(u)"
    }
}

struct Result{
    let property1: String
    let property2: String
    let calculated_result: calculatedRes
}

enum substance_t {
    case Air
    case Nitrogen
    case Water
    case Refrigerant_22
    case Refrigerant_134a
    case Ammonia
    case Propane
}

var Results = [Result]()
var searchFilterResults: [Result] = []

private enum searchCondition_t{
    case p
    case v
    case t
    case h
    case u
}

fileprivate struct sat_dataSource_t{
    let Temp: Float
    let Pressure: Double
    let vf: Double
    let vg: Double
    let uf: Float
    let ug: Float
    let hf: Float
    let hg: Float
    let sf: Float
    let sg: Float
}

fileprivate struct state_t {
    let p: Double
    let t: Float
    let v: Double
    let u: Float
    let h: Float
    let s: Float
}

fileprivate var Water_Sat_Temp_Table = [sat_dataSource_t]() // A2
fileprivate var Water_Sat_Pres_Table = [sat_dataSource_t]() // A3
fileprivate var Sup_Water_Vap_Table = [state_t]() //A4
fileprivate var Com_Water_Liq_Table = [state_t]() //A5

func search(searchCommand: String) {
    var commandStrings = searchCommand.split(separator: ",")
    var SearchResult: Result
    //return SearchResult
}
