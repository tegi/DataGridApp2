//
//  Config.swift
//  DataGridAppServer
//
//  Created by Tomas Tegelhoff on 06/05/16.
//  Copyright © 2016 DataGridApp. All rights reserved.
//

struct Config {
    // host where mysql server is
    static let HOST = "127.0.0.1"
    // mysql username
    static let USER = "root"
    // mysql root password
    static let PASSWORD = "password" // make your password something MUCH safer!!!
    // database name
    static let SCHEMA = "RandomPosts"
}

import Foundation
import CFEnvironment

public struct Configuration {
    
    let port: Int?
    let url: String?
    let firstPathSegment = "todos"
    init() {
        do {
            let appEnv = try CFEnvironment.getAppEnv()
            port = appEnv.port
            url = appEnv.url
        }
        catch _ {
            port = nil
            url = nil
        }
    }
}