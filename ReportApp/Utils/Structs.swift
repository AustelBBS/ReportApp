//
//  Structs.swift
//  ReportApp
//
//  Created by DonauMorgen on 08/05/18.
//  Copyright © 2018 Los Ponis. All rights reserved.
//

import Foundation

typealias JSONArray = [ReportInfo]

struct SignIn : Codable {
    var username : String?
    var email      : String?
    var pass  : String?
}

struct Login : Codable {
    var username : String?
    var pass  : String?
}

struct TestLogin : Codable {
    var token : String?
}

struct Report : Codable {
    var description : String?
    var latitude     : Double?
    var longitude    : Double?
    var type        : String?
}

struct ReportInfo : Codable {
    var ReportID    : Int?
    var DateTime    : String?
    var `Type`      : String?
    var Latitude    : Double?
    var Longitude   : Double?
    var Picture     : String?
    var Description : String?
    var Solved : Bool?
}

struct Geography : Codable {
    var CoordinateSystemId : Int?
    var WellKnownText      : String?
}
