//
//  LoginResponse.swift
//  MatchPoint
//
//  Created by Lucas Salton Cardinali on 13/09/17.
//  Copyright © 2017 Lucas Salton Cardinali. All rights reserved.
//
import ObjectMapper

struct LoginResponse: Mappable {
    var token: String?
    var clientId: String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        token       <- map["token"]
        clientId    <- map["client_id"]
    }
}
