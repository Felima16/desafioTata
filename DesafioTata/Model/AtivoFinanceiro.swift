//
//  AtivoFinanceiro.swift
//  DesafioTata
//
//  Created by Fernanda de Lima on 24/05/2018.
//  Copyright © 2018 FeLima. All rights reserved.
//

import UIKit
import ObjectMapper

class Screen: Mappable{
    
    var title:String?
    var fundName:String?
    var whatIs:String?
    var definition:String?
    var riskTitle:String?
    var risk: Int?
    var infoTitle:String?
    var moreInfo:MoreInfo?
    var info:[Infos]?
    var downInfo:[Infos]?
    
    required init?(map: Map){
        mapping(map: map)
    }
    
    func mapping(map:Map){
        title       <- map["title"]
        fundName    <- map["fundName"]
        whatIs      <- map["whatIs"]
        definition  <- map["definition"]
        riskTitle   <- map["riskTitle"]
        risk        <- map["risk"]
        infoTitle   <- map["infoTitle"]
        moreInfo    <- map["moreInfo"]
        info        <- map["info"]
        downInfo    <- map["downInfo"]
    }
}


class AtivoFinanceiro: Mappable  {
    
    var screen:Screen?
    
    required init?(map: Map){
        mapping(map: map)
    }
    
    func mapping(map:Map){
        screen     <- map["screen"]
    }
}

class MoreInfo:Mappable{
    var month:Numeros?
    var year:Numeros?
    var dozeMonths:Numeros?
    
    
    required init?(map: Map){
        mapping(map: map)
    }
    
    func mapping(map:Map){
        month       <- map["month"]
        year        <- map["year"]
        dozeMonths  <- map["12months"]
    }
}

class Numeros: Mappable  {
    
    var fund:Int?
    var CDI:Int?
    
    required init?(map: Map){
        mapping(map: map)
    }
    
    func mapping(map:Map){
        fund    <- map["fund"]
        CDI     <- map["CDI"]
    }
}

class Infos: Mappable  {
    
    var name:String?
    var data:String?
    
    required init?(map: Map){
        mapping(map: map)
    }
    
    func mapping(map:Map){
        name    <- map["name"]
        data    <- map["data"]
    }
}


