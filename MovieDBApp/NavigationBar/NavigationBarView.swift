//
//  NavigationBarView.swift
//  BajajFineserv_SuperApp
//
//  Created by SayaliWani on 03/03/21.
//  Copyright © 2021 test. All rights reserved.
//

import UIKit

class NavigationBarView: UIView {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var widthBtnSearch: NSLayoutConstraint!
    @IBOutlet var lblTitle: UILabel!
    
    var btnBackClicked : ((_ sender: Any) -> Void)?
    var btnMenuClicked : ((_ sender: Any) -> Void)?
    
    var titleText : String {
        set {
            lblTitle.textColor = UIColor.white
            lblTitle.font = UIFont(name: "Kefa", size: 24)
            lblTitle.text = newValue
        }
        get {
            return lblTitle.text ?? ""
        }
    }
    
        
    @IBAction func onbtnbackClicked(_ sender: Any) {
        btnBackClicked?(sender)
    }
    
    @IBAction func onbtnMenuClicked(_ sender: Any) {
        btnMenuClicked?(sender)
    }
    
}
