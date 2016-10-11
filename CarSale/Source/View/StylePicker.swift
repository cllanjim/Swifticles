//
//  TrimPicker.swift
//  CarSale
//
//  Created by Raptis, Nicholas on 10/10/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

protocol StylePickerDelegate
{
    func didPickStyle(picker: StylePicker, style: EdmundsStyle)
}


class StylePicker : UIView, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate
{
    var delegate: StylePickerDelegate?
    
    var infoPage: VehicleInfoPage?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView!.delegate = self
            tableView!.dataSource = self
        }
    }
    
    //weak var
    private var _header: PlaceholderTableHeader?
    private var headerHeight: CGFloat = 44.0
    
    //var styles = [EdmundsStyle]()
    
    
    func setUp(withInfoPage info: VehicleInfoPage) {
        infoPage = info
        tableView.reloadData()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView!.dequeueReusableCell(withIdentifier: "style_pick", for: indexPath) as! StylePickerCell
        
        let style = infoPage!.styles[indexPath.row]
        
        cell.reset()
        cell.titleLabel.text = style.trim
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62.0
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count = infoPage?.styles.count {
            return count
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let style = infoPage!.styles[indexPath.row]
        
        
        //let model = make.models[indexPath.row]
        //selectedModel = model
        //performSegue(withIdentifier: "model_year_picker", sender: nil)
        
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        
        return headerHeight
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        return nil
    }
    
}








