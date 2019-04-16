//
//  WebService.swift
//  ReportApp
//
//  Created by DonauMorgen on 01/05/18.
//  Copyright © 2018 Los Ponis. All rights reserved.
//

import Alamofire
import UIKit
import Foundation


class WebService {
    
    let BASEURL = "http://uruapan.ddns.net:2020/reportapp"
    
    func testLogin(token: String, method: String, completion:((Bool?) -> Void)?) {
        
        guard let url = URL(string: "\(BASEURL)/api/user/testLogin/") else {
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
                UserDefaults.standard.set(true, forKey: "loggedIn")
                UserDefaults.standard.synchronize()
                completion?(true)
            } else {
                print("No data in response")
                completion?(false)
            }
            
        }
        task.resume()
        
    }
    
    
    func login(data: Data, method: String, completion:((String?) -> Void)?) {
        
        guard let url = URL(string: "\(BASEURL)/api/user/login/") else {
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
                completion?("Error conection timed out")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                var responseCookie = ""
                for cookie in HTTPCookieStorage.shared.cookies! {
                    print("Cookie \(cookie)")
                    responseCookie = cookie.value
                }
                if httpResponse.statusCode == 200 {
                    UserDefaults.standard.set(true, forKey: "loggedIn")
                    completion?(responseCookie)
                } else if httpResponse.statusCode == 302 {
                    if let dato = data, let utf8 = String(data: dato, encoding: .utf8) {
                        completion?(utf8)
                    }
                } else if httpResponse.statusCode == 404 {
                    if let dato = data, let utf8 = String(data: dato, encoding: .utf8) {
                        completion?(utf8)
                    }
                } else {
                    completion?("Error \(httpResponse.statusCode) Please contact the system administrator")
                }
            }
            
        }
        task.resume()
        
    }
    
    func getMessages(data: [String: String], method: String, completion:((Error?, Bool?, Data?) -> Void)?) {
        
        var url = URLComponents(string: "\(BASEURL)/api/messages/get")
        
        var items = [URLQueryItem]()
        
        for (key,value) in data {
            items.append(URLQueryItem(name: key, value: value))
        }
        
        items = items.filter{!$0.name.isEmpty}
        
        if !items.isEmpty {
            url?.queryItems = items
        }
        if let token = UserDefaults.standard.value(forKey: "cookie") {
            let cookieHeaderField = ["Set-Cookie": token]
            let cookies = HTTPCookie.cookies(withResponseHeaderFields: cookieHeaderField as! [String : String], for: (url?.url)!)
            HTTPCookieStorage.shared.setCookies(cookies, for:(url?.url)!, mainDocumentURL: (url?.url)!)
        }
        var request = URLRequest(url: (url?.url)!)
        request.httpMethod = "GET"
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    guard error == nil else {
                        completion?(error, false, nil)
                        return
                    }
                    if let dato = data, let utf8 = String(data: dato, encoding: .utf8) {
                        print("response \(utf8)")
                        if utf8.starts(with: "{\"Message\":\"Errors}") {
                            completion?(nil, false, data)
                        }
                        completion?(nil, true, data)
                    } else {
                        print("No data in response")
                        completion?(nil, false, nil)
                    }
                } else {
                    print("No data in response")
                    print(httpResponse.statusCode)
                    completion?(nil, false, nil)
                }
            }
        }
        task.resume()
    }
    
    func sendMessage(data: Data, method: String, completion:((Error?, Bool?, String?) -> Void)?) {
        guard let url = URL(string: "\(BASEURL)/api/messages/post/") else {
            fatalError("Couldn't parse server address")
        }
        if let token = UserDefaults.standard.value(forKey: "cookie") {
            let cookieHeaderField = ["Set-Cookie": token]
            let cookies = HTTPCookie.cookies(withResponseHeaderFields: cookieHeaderField as! [String : String], for: url)
            HTTPCookieStorage.shared.setCookies(cookies, for:url, mainDocumentURL: url)
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
                completion?(error, false, nil)
                return
            }
            
            if let dato = data, let utf8 = String(data: dato, encoding: .utf8) {
                print("response \(utf8)")
                if utf8.starts(with: "{\"Message\":\"Errors}") {
                    let message : String? = "error"
                    completion?(nil, true, message)
                }
                let message : String? = "success"
                completion?(nil, true, message)
            } else {
                print("No data in response")
                completion?(nil, false, nil)
            }
            
        }
        task.resume()
    }
    
    
    func register(data: Data, method: String, completion:((Error?, Bool?, String?) -> Void)?) {
        guard let url = URL(string: "\(BASEURL)/api/user/post") else {
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
                completion?(error, false, nil)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if let dato = data, let utf8 = String(data: dato, encoding: .utf8) {
                    print("response \(utf8)")
                    if httpResponse.statusCode == 200 {
                        completion?(nil, true, utf8)
                    } else if httpResponse.statusCode == 400 {
                        completion?(nil, false, utf8)
                    } else if httpResponse.statusCode == 500 {
                        let error500 = "Error 500: \(utf8)"
                        completion?(nil, false, error500)
                    }
                } else {
                    print("No data in response")
                    completion?(nil, false, "Invalid request")
                }
            } else {
                print("No data in response")
                completion?(nil, false, nil)
            }
        
        }
        task.resume()
    }
    
    func loadMOTD(token: String, method: String, completion:((Data?) -> Void)?) {
        guard let url = URL(string: "\(BASEURL)/api/feedback/motd/") else {
            fatalError("Couldn't parse server address")
        }
        
        let cookieHeaderField = ["Set-Cookie": token]
        let cookies = HTTPCookie.cookies(withResponseHeaderFields: cookieHeaderField, for: url)
        HTTPCookieStorage.shared.setCookies(cookies, for:url, mainDocumentURL: url)
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
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
    
    func loadReports(token: String, method: String, completion:((Data?) -> Void)?) {
        guard let url = URL(string: "\(BASEURL)/api/report/get/") else {
            fatalError("Couldn't parse server address")
        }
        
        let cookieHeaderField = ["Set-Cookie": token]
        let cookies = HTTPCookie.cookies(withResponseHeaderFields: cookieHeaderField, for: url)
        HTTPCookieStorage.shared.setCookies(cookies, for:url, mainDocumentURL: url)
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            if let statusCode = response as? HTTPURLResponse {
                guard error == nil else {
                    return
                }
                if statusCode.statusCode == 200 {
                    if let dato = data, let utf8 = String(data: dato, encoding: .utf8) {
                        print(utf8)
                        completion?(dato)
                    }
                } else {
                    print(statusCode.statusCode)
                    completion?(nil)
                }
            }
        }
        task.resume()
        
    }
    
    func uploadImage(image : UIImage, id: Int, completion: ((Bool?) -> Void)?) {
        let url = "\(BASEURL)/api/pictures/post/\(id)"
        print(url)
        let imgData = image.jpegData(compressionQuality: 0.2)!
        
        //let parameters = ["name": rname] //Optional for extra parameter
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "report\(id)",fileName: "report_image_\(id).jpg", mimeType: "image/jpg")
            /*for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            } //Optional for extra parameters*/
        }, to: url) { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        print("Upload Progress: \(progress.fractionCompleted)")
                    })
                    
                    upload.responseJSON { response in
                        print("value: \((response.result.value)!)")
                        completion?(true)
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
            }
    }
    
    func sendPost(data: Data, token: String, completion:((Error?, Bool?, Data?) -> Void)?) {
        guard let url = URL(string: "\(BASEURL)/api/report/post/") else {
            fatalError("Couldn't parse server address")
        }
        //print(token)
        let cookieHeaderField = ["Set-Cookie": token]
        let cookies = HTTPCookie.cookies(withResponseHeaderFields: cookieHeaderField, for: url)
        HTTPCookieStorage.shared.setCookies(cookies, for:url, mainDocumentURL: url)
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
                completion?(error, false, data)
                return
            }
            
            if let dato = data, let utf8 = String(data: dato, encoding: .utf8) {
                print("response \(utf8)")
                completion?(nil, true, dato)
            } else {
                print("No data in response")
            }
            
        }
        task.resume()
    }
    
    func sendComments(data: Data, token: String, completion:((Error?, Bool?, Data?) -> Void)?) {
        guard let url = URL(string: "\(BASEURL)/api/feedback/comments/") else {
            fatalError("Couldn't parse server address")
        }
        print(token)
        let cookieHeaderField = ["Set-Cookie": token]
        let cookies = HTTPCookie.cookies(withResponseHeaderFields: cookieHeaderField, for: url)
        HTTPCookieStorage.shared.setCookies(cookies, for:url, mainDocumentURL: url)
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
                completion?(error, false, data)
                return
            }
            
            if let dato = data, let utf8 = String(data: dato, encoding: .utf8) {
                print("response \(utf8)")
                completion?(nil, true, dato)
            } else {
                print("No data in response")
            }
            
        }
        task.resume()
    }
    
}

