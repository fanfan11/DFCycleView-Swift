//
//  DFCycleModel.swift
//  DFCycleView
//
//  Created by user on 11/9/18.
//  Copyright © 2018年 DF. All rights reserved.
//

import UIKit

class DFCycleModel: NSObject {
    
    public var imageUrl : String = ""
    public var summary : String = ""
    
    init(imageUrl : String, summary : String = "") {
        self.imageUrl = imageUrl
        self.summary = summary
        super.init()
    }
    
    
}
