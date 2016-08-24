//
//  ToolBarTop.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 8/16/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class ToolBarTop: UIView, RRSegmentDelegate {
    
    
    
        
    @IBOutlet weak var buttonMenu: TBButton!
    @IBOutlet weak var buttonAddBlob: TBButton!
    
    @IBOutlet weak var segMode: RRSegment!{
        didSet {
            segMode.segmentCount = 3
            //segMode.bu
            
        }
    }
    
    @IBOutlet weak var segEditMode: RRSegment!{
        didSet {
            
            segEditMode.segmentCount = 3
            
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setUp()
    }
    
    internal func setUp() {
        
    }
    
    @IBAction func clickMenu(sender: AnyObject) {
        
        ToolActions.menu()
    }
    
    @IBAction func clickAddBlob(sender: AnyObject) {
        
        ToolActions.addBlob()
    }
    
    func segmentSelected(segment:RRSegment, index: Int) {
        
    }
    
    deinit {
        print("ToolBarTop.deinit()")
    }
    
    
}