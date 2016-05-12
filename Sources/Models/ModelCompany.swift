//
//  ModelCompany.swift
//  DataGridAppServer
//
//  Created by Tomas Tegelhoff on 06/05/16.
//  Copyright © 2016 DataGridApp. All rights reserved.
//

class ModelCompany {

    let id: Int? = nil
    
    let title: String? = nil
    
    let timezone: String? = nil
    
    let domain: String? = nil
    
    let isPublicWeb: Bool = false
    
    let smtp: String? = nil
    
    let isPublicForm: Bool = false
    
    let note: String? = nil
    
    let thankYouMessage: String? = nil
    
    let failMessage: String? = nil
    
    let ocrApplicationId: String? = nil
    
    let ocrPassword: String? = nil

    let googleApiKey: String? = nil
    
    let changed: Int? = nil

    let active: Bool? = nil
    
    func exec() -> Void {
        self.execute()
    }

}
