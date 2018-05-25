//
//  cellJSON.swift
//  DesafioTata
//
//  Created by Fernanda de Lima on 22/05/2018.
//  Copyright © 2018 FeLima. All rights reserved.
//

import UIKit
import ObjectMapper

class cellStruct: Mappable  {
    
    var id:Int?
    var type:Int?
    var message:String?
    var typefield:Any?
    var hidden:Bool?
    var topSpacing: Int?
    var show:Int?
    var required:Bool?
    
    required init?(map: Map){
        mapping(map: map)
    }
    
    func mapping(map:Map){
        id          <- map["id"]
        type        <- map["type"]
        message     <- map["message"]
        typefield   <- map["typefield"]
        hidden      <- map["hidden"]
        topSpacing  <- map["topSpacing"]
        show        <- map["show"]
        required    <- map["required"]
    }
}

class cellJSON: Mappable  {
    
    var cells:[cellStruct]?
    
    required init?(map: Map){
        mapping(map: map)
    }
    
    func mapping(map:Map){
        cells     <- map["cells"]
    }
}
