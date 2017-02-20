//
//  Utils.swift
//  XmppChat
//
//  Created by zhipeng on 17/2/19.
//  Copyright © 2017年 com.baidu.dev. All rights reserved.
//

import UIKit

class Utils : NSObject{
    
  static   var xmppStream:XMPPStream!
  class  func getViewContollerByStoryboaardID(id:String) -> UIViewController{
        return UIStoryboard.init(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(id)
    }
    
}
