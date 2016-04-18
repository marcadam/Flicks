//
//  Utils.swift
//  Flicks
//
//  Created by Marc Anderson on 2/7/16.
//  Copyright © 2016 Marc Anderson. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    static let tableCellHighlightColor = UIColor(red: 23/255, green: 138/255, blue: 250/255, alpha: 1.0)

    enum DateFormat {
        case Long, Short
    }
}

func formatDate(date: String, format: Constants.DateFormat) -> String? {
    var formattedDate: String?

    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    if let date = dateFormatter.dateFromString(date) {

        if format == .Long {
            dateFormatter.dateStyle = .LongStyle
            dateFormatter.timeStyle = .NoStyle
            formattedDate = dateFormatter.stringFromDate(date)
        } else if format == .Short {
            dateFormatter.dateFormat = "MMM yyyy"
            formattedDate = dateFormatter.stringFromDate(date)
        }
    }
    return formattedDate
}
