//
//  HomePageSearchResults.swift
//  CarSale
//
//  Created by Nicholas Raptis on 10/1/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class HomePageSearchResults : UIView, UITableViewDelegate, UITableViewDataSource
{
    weak var homePage: HomePage!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView!.delegate = self
            tableView!.dataSource = self
        }
    }
    
    var searchText: String = ""
    var searchData = [EdmundsSearchModel]()
    var searchResults = [EdmundsSearchModel]()
    
    var selectedModel: EdmundsSearchModel?
    
    var blurEffect = UIBlurEffect(style: .extraLight)
    var _blurEffectView:UIVisualEffectView?
    var blurEffectView:UIVisualEffectView {
        if _blurEffectView == nil {
            _blurEffectView = UIVisualEffectView(frame: bounds)
        }
        return _blurEffectView!
    }
    
    func reset() {
        updateSearchText(text: "")
    }
    
    func animateIn() {
        isHidden = false
        blurEffectView.frame = self.bounds
        tableView.alpha = 0.0
        if blurEffectView.superview == nil {
            self.insertSubview(blurEffectView, belowSubview: tableView!)
        }
        UIView.animate(withDuration: 0.54, delay: 0.1, options: .curveEaseOut, animations: { [weak weakSelf = self] in
            weakSelf?.blurEffectView.effect = weakSelf?.blurEffect
            weakSelf?.tableView?.alpha = 1.0
            }, completion: { didFinish in
        })
    }
    
    func animateOut() {
        UIView.animate(withDuration: 0.54, delay: 0.0, options: .curveEaseIn, animations: { [weak weakSelf = self] in
            weakSelf?.blurEffectView.effect = nil
            weakSelf?.tableView.alpha = 0.0
            }, completion: { [weak weakSelf = self] (didFinish:Bool) in
                weakSelf?.blurEffectView.removeFromSuperview()
                weakSelf?.isHidden = true
            })
    }
    
    func buildSearchTree(models: [EdmundsModel]) {
        searchData.removeAll()
        searchResults.removeAll()
        for model in models {
            let searchModel = EdmundsSearchModel()
            let makeName = model.make.name
            let modelName = model.name
            let title = "\(makeName) \(modelName)"
            let searchText = title.lowercased()
            searchModel.title = title
            searchModel.searchText = searchText
            searchData.append(searchModel)
        }
        tableView.reloadData()
    }
    
    
    func updateSearchText(text: String) {
        searchText = String(text)
        searchResults.removeAll()
        for searchModel in searchData {
            searchModel.matched = false
        }
        let arr = searchText.characters.split{$0 == " "}.map(String.init)
        DispatchQueue.main.async {
            [weak weakSelf = self]  in
            if weakSelf != nil {
                for searchModel in weakSelf!.searchData {
                    if searchModel.matches(searchTerms: arr) {
                        weakSelf!.searchResults.append(searchModel)
                    }
                }
                weakSelf?.tableView.reloadData()
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView!.dequeueReusableCell(withIdentifier: "search_model_cell", for: indexPath) as! SearchResultModelCell
        let searchModel = searchResults[indexPath.row]
        cell.reset()
        cell.titleLabel.text = searchModel.title
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
}












