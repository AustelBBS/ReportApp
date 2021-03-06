//
//  Structs.swift
//  ReportApp
//
//  Created by DonauMorgen on 08/05/18.
//  Copyright © 2018 Los Ponis. All rights reserved.
//

import Foundation
import UIKit
typealias JSONArray = [ReportInfo]
typealias MessageArray = [DownloadMsg]

struct ResponseID : Codable {
   var reportId : Int?
}

struct SignIn : Codable {
    var email      : String
    var username : String
    var pass  : String
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
    var ReportId    : Int?
    var DateTime    : String?
    var `Type`      : String?
    var Latitude    : Double?
    var Longitude   : Double?
    var Picture     : String?
    var Description : String?
    var Solved : Bool?
}

struct Comment : Codable {
    var comments : String?
}

struct SendMsg : Codable {
    var reportId : Int?
    var body : String?
}

struct DownloadMsg : Decodable {
    var UserName : String
    var Body : String
    var DateTime : String
    var ReportId : Int
}

struct Geography : Codable {
    var CoordinateSystemId : Int?
    var WellKnownText      : String?
}

struct MOTD : Codable {
    var Message : String?
    var Date    : String?
}

struct CoachMarkStruct{
    var message : String
    var view : UIView?
}
