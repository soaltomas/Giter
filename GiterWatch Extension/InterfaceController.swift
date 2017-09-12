//
//  InterfaceController.swift
//  GiterWatch Extension
//
//  Created by Артем Полушин on 12.09.17.
//  Copyright © 2017 Артем Полушин. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    private var session : WCSession!

    @IBOutlet var tableWatch: WKInterfaceGroup!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        session = WCSession.isSupported() ? WCSession.default() : nil
        session?.delegate = self
        session?.activate()
        
        sendCommand(cmd: "getRepoList")
    }
    
    override func didDeactivate() {
        session = nil
        super.didDeactivate()
    }
    
    func sendCommand(cmd: String) {
        if let session = session, session.isReachable {
            
            let applicationData = [ "body" : cmd ]
            session.sendMessage(applicationData,
                                replyHandler: { replyData in
                                    print("Send: done")
            }, errorHandler: { error in
                print("Send: fail")
            })
        } else {
            print("No connection")
        }
    }
    
    
    internal func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?){

    }
}
