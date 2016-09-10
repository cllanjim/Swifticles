//
//  EditAffineViewController.swift
//  SwiftFunhouse
//
//  Created by Raptis, Nicholas on 7/18/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class EditAffineViewController: UIViewController {
    
    @IBOutlet weak var segLeft: TBSegment!{
        didSet {
            segLeft.segmentCount = 2
            
        }
    }
    
    @IBOutlet weak var segMiddle: TBSegment!{
        didSet {
            segMiddle.segmentCount = 4
        }
    }
    
    @IBOutlet weak var segRight: TBSegment!{
        didSet {
            segRight.segmentCount = 1
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        print("init?(coder aDecoder: NSCoder) {")
        
        setUp()
    }
    
    override func awakeFromNib() {
        setUp()
        
        
        print("awakeFromNib() {")
        
    }
    
    func setUp() {
        
        print("func setUp() {")
        
    }
    
    
}
