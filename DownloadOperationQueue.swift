# DownloadOperationQueue

### NSOperationQueue subclass to determine when all Operations are finished
#### Using KVO, we observe the "operations" keypath. When it hits zero, it fires the completionBlock?()

        let operationQueue = DownloadOperationQueue()
        
        let blockOperation1 = NSBlockOperation { 
            // Do Stuff
        }
        
        // Custom NSOperation
        let downloadOperation1 = DowloadImageOperation(stringURL: imageURLs[0], delegate: self)

        
        // Set your completion block
        self.operationQueue.completionBlock = {
            print("All finished!")
        }

        operationQueue.addOperations([blockOperation1, downloadOperation1], waitUntilFinished: false)
