//
//  PontoMaisService.swift
//  MatchPoint
//
//  Created by Lucas Salton Cardinali on 13/09/17.
//  Copyright © 2017 Lucas Salton Cardinali. All rights reserved.
//
import Moya

enum PontoMaisService {
    case login(login: String, password: String)
    case register(token: String, client: String, uid: String)
}

extension PontoMaisService: TargetType {
    var baseURL: URL { return URL(string: "https://api.pontomaisweb.com.br")! }
    var path: String {
        switch self {
        case .login(_, _):
            return "/api/auth/sign_in"
        case .register(_, _, _):
            return "/api/time_cards/register"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login, .register:
            return .post
        }
    }

    
    var task: Task {
        switch self {
        case .register(_,_,_):
            return .requestParameters(parameters: ["time_card": [
            "latitude": -23.6015042,
            "longitude": -46.694538,
            "address": "Av. das Nações Unidas, 11541 - Cidade Monções, São Paulo - SP, Brasil",
            "reference_id": "",
            "original_latitude": -23.6015042,
            "original_longitude": -46.694538,
            "original_address": "Av. das Nações Unidas, 11541 - Cidade Monções, São Paulo - SP, Brasil",
            "location_edited": false,
            "accuracy": 30],
            "_path": "/meu_ponto/registro_de_ponto",
            "_device": [
            "cordova": "4.1.0",
            "manufacturer": "unknown",
            "model": "Chrome",
            "platform": "browser",
            "uuid": nil,
            "version": "61.0.3163.79"
        ],
        "_appVersion": "0.10.21"], encoding: JSONEncoding.default)

        case let .login(login, password):
            return .requestParameters(parameters: ["login": login, "password": password],
                                      encoding: JSONEncoding.default)
            
        }
        
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String: String]? {
        var customHeaders = ["Content-type": "application/json"]
        
        switch self {
        case let .register(token, client, email):
            customHeaders["access-token"] = token
            customHeaders["client"] = client
            customHeaders["uid"] = email
        default:
           return customHeaders 
        }
        return customHeaders
    }
    
    

}
