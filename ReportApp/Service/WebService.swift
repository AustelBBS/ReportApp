//
//  WebService.swift
//  ReportApp
//
//  Created by DonauMorgen on 01/05/18.
//  Copyright © 2018 Los Ponis. All rights reserved.
//

import Foundation


class WebService {
    
    
    func testLogin(token: String, method: String, completion:((Bool?) -> Void)?) {
        
        guard let url = URL(string: "http://equipoponny-001-site1.btempurl.com/api/usuario/testLogin/") else {
            fatalError("Couldn't parse server address")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue(token, forHTTPHeaderField: "access_token")
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            
            guard error == nil else {
                return
            }
            print(response)
            
            if let dato = data, let utf8 = String(data: dato, encoding: .utf8) {
                print(utf8)
                if utf8.range(of: "starbacks") != nil {
                    print("Acceso valido!")
                    completion?(true)
                } else {
                    completion?(false)
                }
            } else {
                print("No data in response")
                completion?(false)
            }
            
        }
        task.resume()
        
    }
    
    
    func login(data: Data, method: String, completion:((String?) -> Void)?) {
        
        
        guard let url = URL(string: "http://equipoponny-001-site1.btempurl.com/api/usuario/login/") else {
            fatalError("Couldn't parse server address")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        request.httpBody = data
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            
            guard error == nil else {
                return
            }
            
            if let dato = data, let utf8 = String(data: dato, encoding: .utf8) {
                let start = utf8.index(utf8.startIndex, offsetBy: 17)
                let end = utf8.index(utf8.endIndex, offsetBy: -2)
                let range = start..<end
                let token = String(utf8[range])
                print(token)
                completion?(token)
            } else {
                print("No data in response")
            }
            
        }
        task.resume()
        
    }
    
    func register(data: Data, method: String, completion:((Error?) -> Void)?) {
        guard let url = URL(string: "http://equipoponny-001-site1.btempurl.com/api/usuario/post/") else {
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
                print("response (utf8)")
            } else {
                print("No data in response")
            }
            
        }
        task.resume()
    }
    
    func loadReports(token: String, method: String, completion:((Data?) -> Void)?) {
        guard let url = URL(string: "http://equipoponny-001-site1.btempurl.com/api/reportes/vermios/") else {
            fatalError("Couldn't parse server address")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue(token, forHTTPHeaderField: "access_token")
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            
            guard error == nil else {
                return
            }
            
            if let dato = data, let utf8 = String(data: dato, encoding: .utf8) {
                print(utf8)
                completion?(dato)
            }
        }
        task.resume()
        
    }
    
    func sendPost(data: Data, token: String, completion:((Error?) -> Void)?) {
        guard let url = URL(string: "http://equipoponny-001-site1.btempurl.com/api/reportes/post/") else {
            fatalError("Couldn't parse server address")
        }
        print(token)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(token, forHTTPHeaderField: "access_token")
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
                print("response (utf8)")
            } else {
                print("No data in response")
            }
            
        }
        task.resume()
    }
    
}

