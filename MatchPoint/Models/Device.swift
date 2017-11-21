//
//  Device.swift
//  MatchPoint
//
//  Created by Lucas Salton Cardinali on 13/09/17.
//  Copyright © 2017 Lucas Salton Cardinali. All rights reserved.
//
import ObjectMapper

struct Device: Mappable {
    var cordova: String?
    var manafacturer: String?
    var model: String?
    var platform: String?
    var uuid: String?
    var version: String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        cordova         <- map["cordova"]
        manafacturer    <- map["manafacturer"]
        model           <- map["model"]
        platform        <- map["platform"]
        uuid            <- map["uuid"]
        version         <- map["version"]
    }
}
