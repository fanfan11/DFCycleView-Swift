//
//  ViewController.swift
//  DFCycleView
//
//  Created by user on 11/9/18.
//  Copyright © 2018年 DF. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var carouelSV: DFCycleView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupUI()
    }

    
    func setupUI() {
        view.backgroundColor = UIColor.yellow
//        let carouselSV = DFCycleView.init(frame: CGRect(x: 0, y:0, width:  UIScreen.main.bounds.width, height:  UIScreen.main.bounds.width / 320 * 160))
        carouelSV.backgroundColor = UIColor.gray
//        view.addSubview(carouselSV)
        
        let model0 = DFCycleModel.init(imageUrl: "http://pic.58pic.com/58pic/17/27/03/07B58PIC3zg_1024.jpg")
        let model1 = DFCycleModel.init(imageUrl: "http://pic.58pic.com/58pic/13/56/99/88f58PICuBh_1024.jpg")
        let model2 = DFCycleModel.init(imageUrl: "http://pic.58pic.com/58pic/17/77/53/558d11422a923_1024.png")
        let model3 = DFCycleModel.init(imageUrl: "http://pic.58pic.com/58pic/13/18/14/87m58PICVvM_1024.jpg")
        let model4 = DFCycleModel.init(imageUrl: "http://pic.qiantucdn.com/58pic/17/79/77/41N58PICaMu_1024.jpg")
        
        carouelSV.setCycleData(data: [model0, model1, model2, model3, model4])
    }


}

