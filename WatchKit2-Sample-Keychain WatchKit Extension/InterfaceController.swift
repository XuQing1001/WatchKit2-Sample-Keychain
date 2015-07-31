//
//  InterfaceController.swift
//  WatchKit2-Sample-Keychain WatchKit Extension
//
//  Created by XuQing on 15/7/19.
//  Copyright © 2015年 XuQing1001. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    /* 用于测试的保密数据 */
    let secretInfo = "Password"
    /* 作为保密数据结尾增亮的部分 */
    var count = 1
    
    let account = "账户"
    let srv = "密码服务名"

    @IBOutlet var label: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }

    override func willActivate() {
        super.willActivate()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }

    @IBAction func add(){
        let secretData = "\(secretInfo)\(count)".dataValue
        
        let query : [NSString: NSObject] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccessible: kSecAttrAccessibleWhenUnlocked,
            kSecAttrService: srv,
            kSecAttrAccount: account,
            kSecValueData: secretData ]
        
        SecItemDelete(query as CFDictionaryRef)
        
        let status: OSStatus = SecItemAdd(query as CFDictionaryRef, nil)
        
        if status == noErr {
            label.setText("保存成功，数据是：\(secretInfo)\(count)")
        } else {
            label.setText("保存失败！")
        }
    }
    
    @IBAction func update(){
        let newSecretData = "\(secretInfo)\(++count)".dataValue
        
        let query : [NSString: NSObject] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account]
        
        let update : [NSString: NSObject] = [
            kSecValueData: newSecretData]
        
        let status: OSStatus = SecItemUpdate(query  as CFDictionaryRef, update  as CFDictionaryRef)
        if status == noErr {
            label.setText("更新成功，新数据：\n\(secretInfo)\(count)")
        } else {
            label.setText("更新失败！")
        }
    }
    
    @IBAction func load() {

        let query : [NSString: NSObject] = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrAccount : account,
            kSecAttrService : srv,
            kSecReturnData : kCFBooleanTrue,
            kSecMatchLimit : kSecMatchLimitOne ]

        var dataTypeRef : AnyObject?

        let status: OSStatus = withUnsafeMutablePointer(&dataTypeRef) {
            SecItemCopyMatching(query as CFDictionaryRef, UnsafeMutablePointer($0))
        }
        
        if status == noErr {
            let data = dataTypeRef as! NSData
            label.setText("加载成功，结果为:\n\(data.stringValue)")
        } else {
            label.setText("加载失败！")
        }
    }
    
    @IBAction func delete() {
        let query : [NSString: NSObject] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account]
        
        let status: OSStatus = SecItemDelete(query as CFDictionaryRef)
        
        if status == noErr {
            label.setText("删除成功")
        } else {
            label.setText("删除失败！")
        }
    }
}

extension String {
    public var dataValue: NSData {
        return dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: false)!
    }
}

extension NSData {
    public var stringValue: String {
        return NSString(data: self, encoding: NSUnicodeStringEncoding)! as String
    }
}

