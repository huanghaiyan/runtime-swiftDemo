//
//  ButtonExtension.swift
//  runtime-swiftDemo
//
//  Created by 黄海燕 on 16/6/5.
//  Copyright © 2016年 huanghy. All rights reserved.
//

import UIKit


extension UIButton{
    public override class func initialize(){
        struct once{
            static var once:dispatch_once_t = 0
        }
        dispatch_once(&once.once){
            let originalMethod = #selector(UIButton.sendAction(_:to:forEvent:))
            let myMethod = #selector(UIButton.myButtonClick(_:to:forEvent:))
            
            let original = class_getInstanceMethod(self, originalMethod)
            let mine = class_getInstanceMethod(self, myMethod)
            
            let didAddMethod = class_addMethod(self, originalMethod, method_getImplementation(mine), method_getTypeEncoding(mine))
            if didAddMethod{
                class_replaceMethod(self, myMethod, method_getImplementation(original), method_getTypeEncoding(original))
            }else{
                method_exchangeImplementations(original, mine)
            }
        }
    }
    func myButtonClick(action:Selector,to target:AnyObject?,forEvent event:UIEvent?) {
        print("swizzle Method")
        
//        struct once{
//            static var loopSwitch:Bool = true
//        }
//        
//        if once.loopSwitch {
//            target?.performSelector(action,withObject:self)
//            once.loopSwitch = false
//            let delayTime = dispatch_time(DISPATCH_TIME_NOW,Int64(2*NSEC_PER_SEC))
//            dispatch_after(delayTime, dispatch_get_main_queue(), {
//                once.loopSwitch = true
//            })
//        }else{
//            print("禁止点击")
//        }
        
        struct once{
            static var loopSwitch:Dictionary<String,String> = [:]
        }
        if once.loopSwitch[action.description] != "false" {
            target?.performSelector(action,withObject:self)
            once.loopSwitch[action.description] = "false"
            
            let delayTime = dispatch_time(DISPATCH_TIME_NOW,Int64(2*NSEC_PER_SEC))
                        dispatch_after(delayTime, dispatch_get_main_queue(), {
                            once.loopSwitch[action.description] = "true"
                        })

            
        }else{
            print(action.description+"禁止点击")
        }
    }
    
}

