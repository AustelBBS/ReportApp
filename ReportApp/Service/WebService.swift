//
//  WebService.swift
//  ReportApp
//
//  Created by DonauMorgen on 01/05/18.
//  Copyright © 2018 Los Ponis. All rights reserved.
//

import Foundation

struct SignIn : Codable {
    var nombreUsuario : String?
    var correo : String?
    var passwordHash : String?
}


class WebService {
    
    func register(data: Data, completion:((Error?) -> Void)?) {

        
        guard let url = URL(string: "http://equipoponny-001-site1.btempurl.com//api/usuario/post/") else {
            fatalError("Couldn't parse server address")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        request.httpBody = data
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            
            guard error == nil else {
                completion?(error)
                return
            }
            
            if let dato = data, let utf8 = String(data: dato, encoding: .utf8) {
                print("response \(utf8)")
            } else {
                print("No data in response")
            }
            
        }
        task.resume()
        
    }
    
}
