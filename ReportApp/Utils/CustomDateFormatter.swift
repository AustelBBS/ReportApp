//
//  CustomDateFormatter.swift
//  ReportApp
//
//  Created by Omar Rico on 8/16/18.
//  Copyright © 2018 Los Ponis. All rights reserved.
//

import Foundation

class CustomDateFormatter{
    static let ISO_Pattern = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'zzz"
    static let dateOutputPattern = "MMM dd, yyyy"
    static let dateTimeOutputPattern = "MMM dd, yyyy HH:mm"
    
    class func dateFrom(isoDate: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = ISO_Pattern
        let date = dateFormatter.date(from: isoDate)
        dateFormatter.dateFormat = dateOutputPattern
        if let d = date{
            return dateFormatter.string(from: d)
        }else{
            return nil
        }
    }
    
    class func dateTimeFrom(isoDate: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = ISO_Pattern
        let date = dateFormatter.date(from: isoDate)
        dateFormatter.dateFormat = dateTimeOutputPattern
        if let d = date{
            return dateFormatter.string(from: d)
        }else{
            return nil
        }
    }
}

