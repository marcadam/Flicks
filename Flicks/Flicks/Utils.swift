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
    enum DateFormat {
        case long, short
    }
}

func formatDate(_ date: String, format: Constants.DateFormat) -> String? {
    var formattedDate: String?

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    if let date = dateFormatter.date(from: date) {

        if format == .long {
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .none
            formattedDate = dateFormatter.string(from: date)
        } else if format == .short {
            dateFormatter.dateFormat = "MMM yyyy"
            formattedDate = dateFormatter.string(from: date)
        }
    }
    return formattedDate
}

extension UIColor {
    class func flicksCellHighlightColor() -> UIColor {
        return UIColor(red: 23/255, green: 138/255, blue: 250/255, alpha: 1.0)
    }
}
