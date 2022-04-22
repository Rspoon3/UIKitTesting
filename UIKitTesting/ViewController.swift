//
//  ViewController.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/1/22.
//

import UIKit
//https://jordan-dixon.com/2018/02/03/using-apples-private-apis-with-swift/
class ViewController: UIViewController {
    var faceIDView: UIView!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        faceIDView.setValue(1, forKey: "state")
        faceIDView.perform(NSSelectorFromString("_applyStateAnimated:"))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Bundle(path: "/System/Library/PrivateFrameworks/LocalAuthenticationPrivateUI.framework")?.load()
        
        let GlyphView = NSClassFromString("LAUIPearlGlyphView") as! UIView.Type
        
        faceIDView = GlyphView.init()
        faceIDView.frame = .init(x: view.center.x - 50, y: view.center.y - 50, width: 100, height: 100)
        view.addSubview(faceIDView)
    }
    
    
}

