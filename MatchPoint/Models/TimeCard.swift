//
//  TimeCard.swift
//  MatchPoint
//
//  Created by Lucas Salton Cardinali on 13/09/17.
//  Copyright © 2017 Lucas Salton Cardinali. All rights reserved.
//
import ObjectMapper

struct TimeCard: Mappable {
    var latitude: Double?
    var longitude: Double?
    var address: String?
    var reference_id: String?
    var originalLatitude: Double?
    var originalLongitude: Double?
    var originalAddress: String?
    var locationEdited: Bool?
    var accuracy: Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        latitude            <- map["latitude"]
        longitude           <- map["longitude"]
        address             <- map["address"]
        reference_id        <- map["reference_id"]
        originalLatitude    <- map["originalLatitude"]
        originalLongitude   <- map["originalLongitude"]
        originalAddress     <- map["originalAddress"]
        locationEdited      <- map["locationEdited"]
        accuracy            <- map["accuracy"]
    }
}
