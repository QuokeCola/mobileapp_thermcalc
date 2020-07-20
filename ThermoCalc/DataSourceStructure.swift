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
    func get_result()->String{
        return "State:\(State), P:\(p), V:\(v), T:\(T), h:\(h), u:\(u)"
    }
}

struct searchAttempt{
    var SearchCondition = [searchCondition]()
    var property1: String {
        var header = ""
        if let propertyHeader = SearchCondition[0].property {
            switch propertyHeader{
            case .p:
                header = "p:"
            case .v:
                header = "v:"
            case .t:
                header = "t:"
            case .u:
                header = "u:"
            case .h:
                header = "h:"
            case .s:
                header = "s:"
            }
        }
        return header+SearchCondition[0].amount+SearchCondition[0].unit
    }
    var property2: String {
        var header = ""
        if let propertyHeader = SearchCondition[1].property {
            switch propertyHeader{
            case .p:
                header = "p:"
            case .v:
                header = "v:"
            case .t:
                header = "t:"
            case .u:
                header = "u:"
            case .h:
                header = "h:"
            case .s:
                header = "s:"
            }
        }
        return header+SearchCondition[1].amount+SearchCondition[1].unit
    }
    var substance : substance_t
    let calculated_result: calculatedRes?
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

var Substance: substance_t = .Water
var Results = [searchAttempt]()
var searchFilterResults: [searchAttempt] = []

struct searchCondition {
    var property: PropertyHeader?
    var amount: String
    var unit: String
}

fileprivate struct sat_dataSource_t{
    let Temp: PropertyData
    let Pressure: PropertyData
    let vf: PropertyData
    let vg: PropertyData
    let uf: PropertyData
    let ug: PropertyData
    let hf: PropertyData
    let hg: PropertyData
    let sf: PropertyData
    let sg: PropertyData
}

enum PropertyHeader {
    case p
    case t
    case v
    case u
    case h
    case s
}

struct PropertyData {
    var amount: Double
    var Unit: String
}

struct State {
    let Temp: PropertyData
    let Pressure: PropertyData
    let v: PropertyData
    let u: PropertyData
    let h: PropertyData
    let s: PropertyData
}

fileprivate var Water_Sat_Temp_Table = [sat_dataSource_t]() // A2
fileprivate var Water_Sat_Pres_Table = [sat_dataSource_t]() // A3
fileprivate var Sup_Water_Vap_Table = [State]() //A4
fileprivate var Com_Water_Liq_Table = [State]() //A5

func search(searchCommand: String) {
    //return SearchResult
}
