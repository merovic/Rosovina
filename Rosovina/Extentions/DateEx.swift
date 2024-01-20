//
//  DateEx.swift
//  Teseppas Loylaty
//
//  Created by Amir Ahmed on 16/10/2022.
//

import Foundation

extension Date
{
//    func isBetween(_ startTime: String, and endTime: String) -> Bool {
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "hh:mm:ss"
//        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
//
//        let dateStart = dateFormatter.date(from: startTime)!
//        let dateEnd = (dateFormatter.date(from: endTime) ?? Calendar.current.date(byAdding: .hour, value: -1, to: Date()))!
//
//        return dateStart <= self && self < dateEnd
//    }
    
    func reformatTime(_ time: String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "EG")
        
        let date = dateFormatter.date(from: time)
        
        dateFormatter.dateFormat = "hh:mm a"
        
        return dateFormatter.string(from: date!)
    }
    
    func isBetween(_ startTime: String, and endTime: String) -> Bool {
        
        let current = Date()
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "YY/MM/dd"
        
        let targetStart = dateFormatter.string(from: current) + " " + startTime
        let targetEnd = dateFormatter.string(from: current) + " " + endTime
        
        dateFormatter.dateFormat = "YY/MM/dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "EG")

        let dateStart = Calendar.current.date(byAdding: .hour, value: 2, to: dateFormatter.date(from: targetStart)!)
        let dateEnd = Calendar.current.date(byAdding: .hour, value: 2, to: dateFormatter.date(from: targetEnd)!)
        
        return (dateStart!.compare(self) == .orderedAscending) && (dateEnd!.compare(self) == .orderedDescending)
    }
    
//    func isBetween(startDate:Date, endDate:Date) -> Bool
//    {
//         return (startDate.compare(self) == .orderedAscending) && (endDate.compare(self) == .orderedDescending)
//    }
}
