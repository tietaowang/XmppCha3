//
//  NewChatViewController.swift
//  XmppChat
//
//  Created by zhipeng on 17/2/19.
//  Copyright © 2017年 com.baidu.dev. All rights reserved.
//

import Foundation
class NewChatViewController:ChatBaseViewController,XMPPStreamDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utils.xmppStream.addDelegate(self, delegateQueue: dispatch_get_main_queue())
        
        
    }
    
    func addfriend(name:String){
        var iden = String.init(format: "%@@%@", name,"192.168.0.1")
       var jid = XMPPJID.jidWithString(iden)
        
        
    }
    
//    //name为用户账号
//    - (void)XMPPAddFriendSubscribe:(NSString *)name
//    {
//    //XMPPHOST 就是服务器名，  主机名
//    XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",name,XMPPHOST]];
//    //[presence addAttributeWithName:@"subscription" stringValue:@"好友"];
//    [xmppRoster subscribePresenceToUser:jid];
//    
//    }
    
}
