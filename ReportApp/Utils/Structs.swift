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
    var nombreUsuario : String?
    var correo        : String?
    var passwordHash  : String?
}

struct Login : Codable {
    var nombreUsuario : String?
    var passwordHash  : String?
}

struct TestLogin : Codable {
    var token : String?
}

struct Report : Codable {
    var descripcion : String?
    var latitud     : Double?
    var longitud    : Double?
    var tipo        : String?
}

struct ReportInfo : Codable {
    var idReport  : Int?
    var idUsuario : Int?
    var fechaHora : String?
    var tipo      : String?
    var ubicacion : Geography?
    var foto      : String?
    var descripcion : String?
    var solucionado : String?
}

struct Geography : Codable {
    var CoordinateSystemId : Int?
    var WellKnownText      : String?
}
