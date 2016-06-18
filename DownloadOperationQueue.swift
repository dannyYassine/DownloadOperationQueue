//
//  DowloadImageOperation.swift
//
//  Created by Danny Yassine on 2016-06-18.
//  Copyright © 2016 Danny Yassine. All rights reserved.
//

import UIKit

protocol DownloadImageOperationDelegate {
    func operationProgress(operation: DownloadImageOperation, progress: CGFloat)
    func operationCompletedDownload(operation: DownloadImageOperation, image: UIImage?)
    func operationCompletedWithError(operation: DownloadImageOperation, error: NSError?)
    func operationDidCancel(operation: DownloadImageOperation)
}

class DownloadImageOperation: NSOperation {

    var delegate: DownloadImageOperationDelegate?
    
    private var isExecuting: Bool
    private var isFinished: Bool
    private var isCancelled: Bool
    
    private var stringUrl: String!
    var url: String! {
        return self.stringUrl
    }
    
    override var asynchronous: Bool {
        return true
    }
    
    override var executing: Bool {
        get {
            return self.isExecuting
        }
        set {
            willChangeValueForKey("isExecuting")
            self.isExecuting = newValue
            didChangeValueForKey("isExecuting")
        }
    }
    
    override var finished: Bool {
        get {
            return self.isFinished
        }
        set {
            willChangeValueForKey("isFinished")
            self.isFinished = newValue
            didChangeValueForKey("isFinished")
            
        }
    }
    
    override var cancelled: Bool {
        get {
            return self.isCancelled
        }
        set {
            willChangeValueForKey("isCancelled")
            self.isCancelled = newValue
            didChangeValueForKey("isCancelled")
            
            if newValue == true {
                self.delegate?.operationDidCancel(self)
            }
        }
    }
    
    init(stringURL: String, delegate: DownloadImageOperationDelegate?) {
        
        self.isCancelled = false
        self.isExecuting = false
        self.isFinished = false
        
        super.init()
        
        self.stringUrl = stringURL
        self.delegate = delegate
        
    }
    
    override func main() {
        super.main()
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        let request = NSURLRequest(URL: NSURL(string: url)!)
        let downloadTask = session.downloadTaskWithRequest(request)
        downloadTask.resume()
        
    }
    
    override func start() {
        super.start()
        
        if self.isExecuting == true {
            return
        }
        
        self.executing = true
        NSThread.detachNewThreadSelector(#selector(main), toTarget: self, withObject: nil)
        
    }
}

extension DownloadImageOperation: NSURLSessionDownloadDelegate {
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        let image = UIImage(data: NSData(contentsOfURL: location)!)
        self.delegate?.operationCompletedDownload(self, image: image)
        self.executing = false
        self.finished = true
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        self.delegate?.operationProgress(self, progress: progress)
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        self.delegate?.operationCompletedWithError(self, error: error)
        self.executing = false
        self.finished = true
    }
    
}
