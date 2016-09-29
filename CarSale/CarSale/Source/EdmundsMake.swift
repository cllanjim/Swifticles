//
//  EdmundsMakeModel.swift
//  CarSale
//
//  Created by Raptis, Nicholas on 9/28/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class EdmundsMake
{
    var id: Int = -1
    var idString: String = ""
    
    var name: String = ""
    var niceName: String = ""
    
    var models = [EdmundsModel]()
    
    func load(data:[String:Any]?) -> Bool {
        
        models.removeAll()
        
        guard let _data = data else {
            return false
        }
        
        let _id = _data["id"] as? Int
        let _name = _data["name"] as? String
        
        guard _id != nil && _name != nil else {
            return false
        }
        
        name = _name!
        id = _id!
        idString = String(id)
        
        let _niceName = _data["niceName"] as? String
        if _niceName != nil { niceName = _niceName! }
        
        let _models = _data["models"] as? [[String:Any]]
        if _models != nil {
            for _model in _models! {
                let model = EdmundsModel()
                if model.load(data: _model) {
                    models.append(model)
                }
            }
        }
        
        
        
        
        
        /*
        id = 200038885;
        models =     (
            {
                id = "smart_fortwo";
                name = fortwo;
                niceName = fortwo;
                years =             (
                    {
        
                    },
                    {
                        id = 100526395;
                        year = 2009;
                    },
                    {
                        id = 100530969;
                        year = 2010;
                    },
                    {
                        id = 100533749;
                        year = 2011;
                    },
                    {
                        id = 100532009;
                        year = 2012;
                    },
                    {
                        id = 200418482;
                        year = 2013;
                    },
                    {
                        id = 200497815;
                        year = 2014;
                    },
                    {
                        id = 200704750;
                        year = 2015;
                    },
                    {
                        id = 200705423;
                        year = 2016;
                    }
                );
            }
        );
        */
        
        return true
    }
    
}

