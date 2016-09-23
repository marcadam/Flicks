//
//  NetworkErrorView.swift
//  Flicks
//
//  Created by Marc Anderson on 2/4/16.
//  Copyright © 2016 Marc Anderson. All rights reserved.
//

import UIKit

class NetworkErrorView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var errorLabel: UILabel!

    var error: String? {
        get { return errorLabel?.text }
        set { errorLabel.text = newValue }
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }

    func initSubviews() {
        let nib = UINib(nibName: "NetworkErrorView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }
}
