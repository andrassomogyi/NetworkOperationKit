//
//  NetworkOperation.swift
//  NetworkOperation
//
//  Created by András Somogyi on 03/03/16.
//
//

import Foundation

class NetworkOperation: NSOperation, NSURLSessionDelegate {
    
    let incomingData = NSMutableData()
    var sessionTask: NSURLSessionTask?
    var urlString: String = ""
    var networkCompletion:((NSURLResponse)->Void)!
    var networkError:((NSError)->Void)!
    
    func initNetworkOperation(url: String, successClosure: (response: NSURLResponse) -> Void, errorClosure: (error: NSError) -> Void) {
        urlString = url
        networkCompletion = successClosure
        networkError = errorClosure
    }
    
    var state: Bool = false
    override var finished: Bool {
        get {
            return state
        }
        set (newState) {
            willChangeValueForKey("isFinished")
            state = newState
            didChangeValueForKey("isFinished")
        }
    }
    
    var localURLSession: NSURLSession {
        return NSURLSession(configuration: localConfig, delegate: self, delegateQueue: nil)
    }
    
    var localConfig: NSURLSessionConfiguration {
        return NSURLSessionConfiguration.defaultSessionConfiguration()
    }
    
    override func start() {
        if cancelled {
            finished = true
            return
        }
        guard let url = NSURL(string: urlString) else {fatalError("Failed to build URL.")}
        
        let request = NSMutableURLRequest(URL: url)
        
        sessionTask = localURLSession.dataTaskWithRequest(request)
        sessionTask!.resume()
    }
    
    func URLSession(session: NSURLSession,
        dataTask: NSURLSessionDataTask,
        didReceiveResponse response: NSURLResponse,
        completionHandler: (NSURLSessionResponseDisposition) -> Void) {
            if cancelled {
                finished = true
                return
            }
            completionHandler(.Allow)
            networkCompletion(response)
    }
    
    func URLSession(session: NSURLSession,
        dataTask: NSURLSessionDataTask,
        didReceiveData data: NSData) {
            if cancelled {
                finished = true
                return
            }
            incomingData.appendData(data)
    }
    
    func URLSession(session: NSURLSession,
        task: NSURLSessionTask,
        didCompleteWithError error: NSError?) {
            if cancelled {
                finished = true
                return
            }
            if NSThread.isMainThread() {NSLog("Main thread!")}
            if error != nil {
                NSLog("Failed to receive response \(error)")
                networkError(error!)
                finished = true
                return
            }
    }
}
