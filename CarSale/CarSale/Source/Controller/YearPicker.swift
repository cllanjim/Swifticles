//
//  YearPickerViewController.swift
//  CarSale
//
//  Created by Raptis, Nicholas on 10/3/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class YearPicker: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    weak var homePage: HomePage!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView!.delegate = self
            tableView!.dataSource = self
        }
    }
    
    var model: EdmundsModel?
    
    override func viewWillAppear(_ animated: Bool) {
        //ImageDownloader.shared.delegate = self
        ApplicationController.shared.navigationController.setNavigationBarHidden(false, animated: true)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if model != nil {
            return model!.years.count
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView!.dequeueReusableCell(withIdentifier: "search_model_cell", for: indexPath) as! SearchResultModelCell
        
        let year = model!.years[indexPath.row]
        cell.reset()
        
        //cell.titleLabel.text = searchModel.title
        
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //let searchModel = searchResults[indexPath.row]
        //homePage.selectedModel = searchModel.model
        //homePage.performSegue(withIdentifier: "year_picker", sender: nil)
        
    }
    
}












