//
//  ModelManager.swift
//  DesafioTata
//
//  Created by Fernanda de Lima on 22/05/2018.
//  Copyright © 2018 FeLima. All rights reserved.
//

import UIKit

let mm = ModelManager.instance
class ModelManager: NSObject {
    
    //Singleton struct
    static let instance = ModelManager()
    
    //representaçoes das models
    var cellJSON: cellJSON?
    var ativos: AtivoFinanceiro?
}

