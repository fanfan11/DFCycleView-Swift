//
//  DFCycleView.swift
//  DFCycleView
//
//  Created by user on 11/9/18.
//  Copyright © 2018年 DF. All rights reserved.
//

import UIKit
import Kingfisher

let kDefalutImageName = "image_default"
let kBottomH : CGFloat = 30
let kTimeSecond : Double = 5

class DFCycleView: UIView {
    
    
    //TODO: private property
    fileprivate lazy var scrollView : UIScrollView = {[weak self] in
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.isScrollEnabled = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    fileprivate lazy var leftIV : UIImageView = {
        return UIImageView()
    }()
    fileprivate lazy var centerIV : UIImageView = {
        return UIImageView()
    }()
    fileprivate lazy var rightIV : UIImageView = {
        return UIImageView()
    }()
    fileprivate lazy var bottomView : UIView = {
        let bottomView = UIView()
        bottomView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return bottomView
    }()
    fileprivate lazy var summaryLabel : UILabel = {
        return UILabel()
    }()
    fileprivate lazy var pageControl : UIPageControl = {
        return UIPageControl()
    }()
    
    fileprivate var dataArray : [DFCycleModel]?
    
    fileprivate var timer : Timer?
    
    fileprivate var currentPage : Int = 0


    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        setupUI()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.adjustFrame()
    }
    
}

//TODO: UI
extension DFCycleView {
    func setupUI() {
        addSubview(scrollView)
        scrollView.addSubview(leftIV)
        scrollView.addSubview(centerIV)
        scrollView.addSubview(rightIV)
        addSubview(bottomView)
        bottomView.addSubview(summaryLabel)
        bottomView.addSubview(pageControl)
    }
    
    //TODO:适配
    func adjustFrame() {
        let frame = self.bounds
        scrollView.frame = frame
        leftIV.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        centerIV.frame = CGRect(x: frame.width, y: 0, width: frame.width, height: frame.height)
        rightIV.frame = CGRect(x: frame.width * 2, y: 0, width: frame.width, height: frame.height)
        
        bottomView.frame = CGRect(x: 0, y: frame.height - kBottomH, width: frame.width, height: kBottomH)
        summaryLabel.frame = CGRect(x: 10, y: 0, width: frame.width, height: kBottomH)
        let pageSize = pageControl.size(forNumberOfPages: (dataArray?.count ?? 0))
        pageControl.frame = CGRect(x: frame.width - 10 - pageSize.width, y: 0, width: pageSize.width, height: kBottomH)
        
        scrollView.contentSize = CGSize(width: frame.width * 3, height: frame.height)
        scrollView.setContentOffset(CGPoint(x: frame.width, y: 0), animated: false)
        
    }
}



//TODO: private method
extension DFCycleView {
    /// 定时器自动轮播
    @objc func animalImage() {
        UIView.animate(withDuration: 0.25, animations: {
            self.scrollView.setContentOffset(CGPoint(x: self.frame.width * 2, y: 0), animated: false)
        }) { (finished) in
            if finished {
                self.updateCurrentPageDirector(isRight: false)
                self.updateScrollViewAndImage()
            }
        }
    }
    
    /// 滚动后更新scrollView的位置和显示的图片
    func updateScrollViewAndImage() {
        
        scrollView.setContentOffset(CGPoint(x: self.frame.width, y: 0), animated: false)
        let pageCount = dataArray?.count ?? 0
        if pageCount == 0 {
            return
        }
        
        let leftIndex = currentPage > 0 ? (currentPage - 1) : (pageCount - 1)
        let rightIndex = currentPage < (pageCount - 1) ? (currentPage + 1) : 0
        guard let dataArray = dataArray else { return }
        
        let leftModel = dataArray[leftIndex]
        let centerModel = dataArray[currentPage]
        let rightModel = dataArray[rightIndex]
        
        summaryLabel.text = centerModel.summary
        pageControl.currentPage = currentPage
        
        guard let leftUrl = URL(string: leftModel.imageUrl), let rightUrl = URL(string: rightModel.imageUrl), let centerUrl = URL(string: centerModel.imageUrl)  else {
            return
        }
        leftIV.kf.setImage(with: leftUrl, placeholder: UIImage(named: kDefalutImageName), options: nil, progressBlock: nil, completionHandler: nil)
        centerIV.kf.setImage(with: centerUrl, placeholder: UIImage(named: kDefalutImageName), options: nil, progressBlock: nil, completionHandler: nil)
        rightIV.kf.setImage(with: rightUrl, placeholder: UIImage(named: kDefalutImageName), options: nil, progressBlock: nil, completionHandler: nil)

    }
    
    /// 更新当前的index
    func updateCurrentPageDirector(isRight : Bool) {
        let pageCount = dataArray?.count ?? 0
        if pageCount == 0 {
            return
        }
        if isRight {
            currentPage = currentPage > 0 ? (currentPage - 1) : (pageCount - 1)
        } else {
            currentPage = (currentPage + 1) % pageCount
        }
    }
    
}

//TODO: UIScrollViewDelegate
extension DFCycleView : UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0 {
            updateCurrentPageDirector(isRight: true)
        } else if scrollView.contentOffset.x > scrollView.frame.width {
            updateCurrentPageDirector(isRight: false)
        } else {
            return
        }
        updateScrollViewAndImage()
        
        fireTimer()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        invalidateTimer()
    }
}

//TODO: public method
extension DFCycleView {
    public func setCycleData(data : [DFCycleModel]?) {
        dataArray = data
        currentPage = 0
        pageControl.numberOfPages = data?.count ?? 0
        updateScrollViewAndImage()
        adjustFrame()
        scrollView.isScrollEnabled = data?.count ?? 0 > 1
        fireTimer()
    }
    
    public func invalidateTimer() {
        guard let timer = timer else { return }
        timer.invalidate()
    }
    
    public func fireTimer() {
        invalidateTimer()
        let total = dataArray?.count ?? 0
        if total > 1 {
            timer = Timer.scheduledTimer(timeInterval: kTimeSecond, target: self, selector: #selector(animalImage), userInfo: nil, repeats: true)
        }
    }
}






