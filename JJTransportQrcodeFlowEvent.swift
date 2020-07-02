//
//  JJTransportQrcodeFlowEvent.swift
//
//  Created by chiehchun.lee on 2020/7/2.
//  Copyright © 2020 chiehchun.lee All rights reserved.
//

import Foundation

protocol JJTransportQrcodeFlowResultReceiverProtocol : class {
    /** resultName : Implying next step. ex. "gotoDebugPage"*/
    func jj_sendTransportQrcodeFlowResult(_ ResultName : String)
}

class JJTransportQrcodeFlowEvent {
    private weak var _failFlow : JJTransportQrcodeFlowEvent?
    private weak var _successFlow : JJTransportQrcodeFlowEvent?
    private weak var _resultReceiver : JJTransportQrcodeFlowResultReceiverProtocol!
    
    final func registFail(_ next: JJTransportQrcodeFlowEvent)-> JJTransportQrcodeFlowEvent{
        _failFlow = next
        return self
    }
    
    final func registSuccess(_ next: JJTransportQrcodeFlowEvent)->JJTransportQrcodeFlowEvent {
        _successFlow = next
        return self
    }
    
    final func start(_ resultReceiver : JJTransportQrcodeFlowResultReceiverProtocol) {
        self._resultReceiver = resultReceiver
        self.transaction { [weak self](isSuccess) in
            guard let _wself = self else {return}
            if (isSuccess) {
                _wself._failFlow?.start(_wself._resultReceiver)
            }else {
                _wself._successFlow?.start(_wself._resultReceiver)
            }
        }
    }
    
    final func sendResult(_ resultName : String) {
        self._resultReceiver.jj_sendTransportQrcodeFlowResult(resultName)
    }
    
    func transaction(_ completeHandler : (_ isSuccess : Bool)->()) {
        //need override
        #if DEBUG
            assertionFailure("Needs to be override")
        #endif
    }
}

//ex. 是否有能力
class JJIsUserCapableFlow: JJTransportQrcodeFlowEvent {
    override func transaction(_ completeHandler: (Bool) -> ()) {
        completeHandler(true)
    }
}
