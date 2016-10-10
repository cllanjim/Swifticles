//
//  AltModelPickerPage.swift
//  CarSale
//
//  Created by Raptis, Nicholas on 10/7/16.
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
    
    @IBOutlet weak var stickyHeader: UIView!
    @IBOutlet weak var stickyHeaderImageView: UIImageView!
    
    @IBOutlet weak var stickyHeaderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var stickyHeaderTopConstraint: NSLayoutConstraint!
    
    var headerImage: UIImage? {
        didSet {
            if stickyHeaderImageView != nil {
                stickyHeaderImageView.image = headerImage
            }
        }
    }
    
    
    //weak var
    private var _header: AltModelPickerTableHeader?
    private var headerHeight: CGFloat = 150.0
    
    weak var selectedModel: EdmundsModel?
    
    var imageSets = [ImageSet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stickyHeaderImageView.image = headerImage
        
        let oq = OperationQueue()
        let downloadOp = BlockOperation { [weak weakSelf = self]  in
            if let set = weakSelf?.make.set {
                if let url = URL(string: set.imageURL) {
                    do {
                        let data = try Data(contentsOf: url, options: Data.ReadingOptions.uncached)
                        let image = UIImage(data: data)
                        DispatchQueue.main.async { [weak checkSelf = weakSelf]  in
                            if checkSelf != nil {
                                checkSelf?.headerImage = image
                            }
                        }
                    } catch {
                        print("Unable to load fullsize image [\(set.imageURL)]")
                    }
                }
            }
        }
        oq.addOperations([downloadOp], waitUntilFinished: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ApplicationController.shared.navigationController.setNavigationBarHidden(false, animated: true)
        //Adjust the sticky header after the nav bar appears, the inset will change.
        adjustStickyHeader()
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
        selectedModel = model
        performSegue(withIdentifier: "model_year_picker", sender: nil)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        adjustStickyHeader()
    }
    
    func adjustStickyHeader() {
        let offsetY = tableView.contentOffset.y
        let insetTop = tableView.contentInset.top
        var y = -offsetY
        var height = headerHeight
        if y > insetTop {
            height += (y - insetTop)
            y = insetTop
        }
        
        stickyHeaderTopConstraint.constant = y
        stickyHeaderHeightConstraint.constant = height
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return headerHeight
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if _header == nil {
            _header = AltModelPickerTableHeader(frame: CGRect(x: 0.0, y: 0.0, width: view.bounds.size.width, height: headerHeight))
            _header?.backgroundColor = UIColor.clear
        }
        return _header
    }
    
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
