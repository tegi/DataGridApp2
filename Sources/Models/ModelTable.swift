//
//  ModelBase.swift
//  DataGridAppServer
//
//  Created by Tomas Tegelhoff on 06/05/16.
//  Copyright © 2016 DataGridApp. All rights reserved.
//

import MySQL

extension ModelCompany: ModelTable {
    
}

protocol ModelTable {
    
}

var statement_: String = ""

extension ModelTable {
    
    var statement: String {
        get {
            return statement_
        }
        set {
            statement_ = newValue
        }
    }
    
    mutating func select() -> Self {
        self.statement = "SELECT "
        let propertyNames = self.propertyNames()
        for (index,prop) in propertyNames.enumerate() {
            statement += prop + ", "
            if index < propertyNames.count {
                statement = ","
            }
        }
        self.statement += " FROM " + classNameAsString() + " "
        
        return self
    }
    
    mutating func equal(condition: String) -> Self {
        
        self.statement += condition + " "
        return self
    }
    
    func debug() -> Self {
        debugPrint(self.statement)
        return self
    }
    
    func execute() -> MySQL.Results? {
        
        debugPrint(self.statement)
        
        let mysql = MySQL()
        
        let connected = mysql.connect(Config.HOST, user: Config.USER, password: Config.PASSWORD)
        guard connected else {
            // verify we connected successfully
            print(mysql.errorMessage())
            return nil
        }
        
        // select database
        let schemaExists = mysql.selectDatabase(Config.SCHEMA)
        guard schemaExists else {
            print(mysql.errorMessage())
            return nil
        }
        
        // run our select query
        let querySuccess = mysql.query(self.statement)
        
        // defering close ensure the connection is close when we're done here.
        defer {
            mysql.close()
        }
        
        // make sure the query worked
        guard querySuccess else {
            print(mysql.errorMessage())
            return nil
        }
        
        // now fetch the results
        let results = mysql.storeResults()!
        // we check for one row because we had the LIMIT 1 in our query
        guard results.numRows() == 1 else {
            print("no rows found")
            return nil
        }
        
        return results
    }
    
    func save() {
        
    }
    
    func createTable()
    {
        debugPrint(self.statement)
        
        let mysql = MySQL()
        
        let connected = mysql.connect(Config.HOST, user: Config.USER, password: Config.PASSWORD)
        guard connected else {
            // verify we connected successfully
            print(mysql.errorMessage())
            return
        }
        
        // defering close ensure the connection is close when we're done here.
        defer {
            mysql.close()
        }
        
        // create DB schema if needed
        var schemaExists = mysql.selectDatabase(Config.SCHEMA)
        if !schemaExists {
            schemaExists = mysql.query("CREATE SCHEMA \(Config.SCHEMA) DEFAULT CHARACTER SET utf8mb4;")
        }
        
        var statementCreate = "CREATE TABLE IF NOT EXISTS \(classNameAsString()) "
        
        
        
        for c in Mirror(reflecting: self).children
        {
            if let name = c.label{
                if (name != "statement") {
                    if self.propertyIsOfType(name, type: PropertyTypes.Int)
                    {
                        if (name == "id") {
                            statementCreate += "(id INT(11) AUTO_INCREMENT PRIMARY KEY, "
                        } else {
                            statementCreate += "\(name) INT(11), "
                        }
                    }
                    else if self.propertyIsOfType(name, type: PropertyTypes.OptionalInt)
                    {
                        if (name == "id") {
                            statementCreate += "(id INT(11) AUTO_INCREMENT PRIMARY KEY, "
                        } else {
                            statementCreate += "\(name) INT(11), "
                        }
                    }
                    else if self.propertyIsOfType(name, type: PropertyTypes.String)
                    {
                        statementCreate += "\(name) varchar(255), "
                    }
                    else if self.propertyIsOfType(name, type: PropertyTypes.OptionalString)
                    {
                        statementCreate += "\(name) varchar(255), "
                    }
                    else if self.propertyIsOfType(name, type: PropertyTypes.Bool)
                    {
                        statementCreate += "\(name) boolean, "
                    }
                    else if self.propertyIsOfType(name, type: PropertyTypes.OptionaBool)
                    {
                        statementCreate += "\(name) boolean, "
                    }
                }
            }
        }
        
        statementCreate += ")"
        
        let tableSuccess = mysql.query(statementCreate)
        
        guard schemaExists && tableSuccess else {
            print(mysql.errorMessage())
            return
        }
    }
    
    // ---------------------------------------------------------------------------------------------
    // inspect properties
    // ---------------------------------------------------------------------------------------------
    
    func propertyNames()->[String]{
        var s = [String]()
        for c in Mirror(reflecting: self).children
        {
            if let name = c.label{
                if (name != "statement") {
                    s.append(name)
                }
            }
        }
        return s
    }
    
    func classNameAsString() -> String {
        return String(self.dynamicType)
    }
    
    // ---
    
    //returns the property type
    func getTypeOfProperty(name:String)->String?
    {
        let type: Mirror = Mirror(reflecting:self)
        
        for child in type.children {
            if child.label! == name
            {
                return String(child.value.dynamicType)
            }
        }
        return nil
    }
    
    //Property Type Comparison
    func propertyIsOfType(propertyName:String, type:PropertyTypes)->Bool
    {
        if getTypeOfProperty(propertyName) == type.rawValue
        {
            return true
        }
        
        return false
    }
}

enum PropertyTypes:String
{
    case Int = "Int"
    case OptionalInt = "Optional<Int>"
    case Bool = "Bool"
    case OptionaBool = "Optional<Bool>"
    case String = "String"
    case OptionalString = "Optional<String>"
}

