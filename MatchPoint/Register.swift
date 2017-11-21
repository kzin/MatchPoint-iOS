//
//  Register.swift
//  MatchPoint
//
//  Created by Lucas Salton Cardinali on 13/09/17.
//  Copyright © 2017 Lucas Salton Cardinali. All rights reserved.
//
import ObjectMapper

struct Register: Mappable {
    var timeCard: TimeCard?
    var path: String?
    var device: Device?
    var appVersion: String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        timeCard    <- map["time_card"]
        path        <- map["_path"]
        device      <- map["_device"]
        appVersion  <- map["_appVersion"]
    }
}
