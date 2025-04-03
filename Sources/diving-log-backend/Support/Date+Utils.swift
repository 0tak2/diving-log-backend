//
//  Date+Utils.swift
//  diving-log-backend
//
//  Created by 임영택 on 4/3/25.
//

import Foundation

extension Date {
    func adding(days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
}
