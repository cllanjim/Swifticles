//
//  AltModelPickerPage.swift
//  CarSale
//
//  Created by Raptis, Nicholas on 10/7/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import Foundation

//
//  ModelPickerPage.swift
//  CarSale
//
//  Created by Raptis, Nicholas on 10/5/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class AltModelPickerPage : UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate
{
    var make: EdmundsMake!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView!.delegate = self
            tableView!.dataSource = self
        }
    }
    
    
    //weak var
    private var _header: AltModelPickerTableHeader?
    private var headerHeight: CGFloat = 150.0
    
    weak var selectedModel: EdmundsModel?
    
    var imageSets = [ImageSet]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ApplicationController.shared.navigationController.setNavigationBarHidden(false, animated: true)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return make.models.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView!.dequeueReusableCell(withIdentifier: "model_cell", for: indexPath) as! ModelTableCell
        let model = make.models[indexPath.row]
        cell.reset()
        cell.titleLabel.text = model.name
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = make.models[indexPath.row]
        
        //let searchModel = searchResults[indexPath.row]
        //homePage.selectedModel = searchModel.model
        //homePage.performSegue(withIdentifier: "year_picker", sender: nil)
        
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard let header = _header else {
            return
        }
        print("CONTENT OFFSET Y = \(scrollView.contentOffset.y)")
        if scrollView.contentOffset.y <= 0.0 {
            
            var extra = (-scrollView.contentOffset.y * scrollView.contentScaleFactor)
            
            var t = CGAffineTransform.identity
            t = t.translatedBy(x: 0.0, y: extra)
            
            header.transform = t
            
            
            header.frame = CGRect(x: 0.0, y: 0.0, width: tableView.frame.size.width, height: headerHeight + extra)
            print("ADJUSTED FRAM = \(header.frame.origin.x) \(header.frame.origin.y) .. \(header.frame.size.width) x \(header.frame.size.height)")
            
            
        } else {
            if header.frame.size.height != headerHeight {
                
                var t = CGAffineTransform.identity
                header.transform = t
                header.frame = CGRect(x: header.frame.origin.x, y: 0.0, width: tableView.frame.size.width, height: headerHeight)
                
            }
        }
        header.backgroundColor = UIColor(red: 1.0, green: 0.2, blue: 0.6, alpha: 0.6)
        header.imageView?.frame = CGRect(x: 0.0, y: 0.0, width: header.bounds.size.width, height: header.bounds.size.height)
        
        
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return headerHeight
    }
    
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if _header == nil {
            _header = AltModelPickerTableHeader(frame: CGRect(x: 0.0, y: 0.0, width: view.bounds.size.width, height: headerHeight))
        }
        return _header
    }
    
    // custom view for header. will be adjusted to default or specified header height
    
    
    @IBAction func clickModel(_ button: CellHighlightButton) {
        if let cell = button.superview?.superview as? ModelPageCell {
            selectedModel = cell.model
            performSegue(withIdentifier: "model_year_picker", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "model_year_picker" {
            if let yearPicker = segue.destination as? YearPickerPage {
                yearPicker.navigationItem.title = selectedModel!.make.name + " " + selectedModel!.name
                yearPicker.model = selectedModel
                yearPicker.imageSets = imageSets
            }
        }
    }
}
