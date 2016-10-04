//
//  SearchNode.swift
//  CarSale
//
//  Created by Nicholas Raptis on 10/1/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class SearchNode : NSObject
{
    var title: String = ""
    
    var matched: Bool = false
    
    var terms = [String]()
    
    var searchText: String = "" {
        didSet {
            //Split the text into words...
            terms.removeAll()
            if searchText.characters.count > 0 {
                let arr = searchText.characters.split{$0 == " "}.map(String.init)
                for term in arr {
                    terms.append(term)
                }
            }
        }
    }
    
    //Do ALL of the words match our search term?
    func matches(searchTerms: [String?]) -> Bool {
        var anyMatch = false
        var allMatch = true
        for tryTerm in searchTerms {
            if tryTerm != nil {
                var anyMatchTerm = false
                for term in terms {
                    if term.range(of: tryTerm!) != nil {
                        
                        anyMatchTerm = true
                    }
                }
                if anyMatchTerm == false {
                    allMatch = false
                } else {
                    anyMatch = true
                }
            }
        }
        return anyMatch && allMatch
    }
    
    //Do ANY of the words match our search term?
    func matches(searchTerm: String?) -> Bool {
        if searchTerm != nil {
            for term in terms {
                if term.range(of: searchTerm!) != nil {
                    return true
                }
            }
        }
        return false
    }
    
    
    
    
    
}
