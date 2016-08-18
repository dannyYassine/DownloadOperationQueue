//
//  DownlodOperationQueue.swift
//  ConcurrencyDemo
//
//  Created by Danny Yassine on 2016-06-18.
//  Copyright © 2016 Hossam Ghareeb. All rights reserved.
//

import UIKit

class DownloadOperationQueue: NSOperationQueue {

    private static var operationsKeyPath: String {
        return "operations"
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: "operations")
    }
    
    var completionBlock: (() -> Void)?
    
    override init() {
        super.init()
        
        self.addObserver(self, forKeyPath: DownloadOperationQueue.operationsKeyPath, options: .New, context: nil)
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if let operationPath = keyPath where operationPath == DownloadOperationQueue.operationsKeyPath {
            if self.operations.count == 0 {
                NSOperationQueue.mainQueue().addOperationWithBlock({ 
                    self.completionBlock?()
                })
            }
        }
    }
    
}
