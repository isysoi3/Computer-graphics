//
//  ViewController.swift
//  lab2
//
//  Created by Ilya Sysoi on 3/8/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet var infoTextView: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureSubviews()
    }
    
    private func configureSubviews() {
        infoTextView.string = ""
        infoTextView.isEditable = false
    }
    
}


extension ViewController {
    
    
}
