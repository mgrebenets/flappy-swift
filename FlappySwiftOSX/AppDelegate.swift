//
//  AppDelegate.swift
//  FlappySwiftOSX
//
//  Created by Grebenets, Maksym on 8/24/14.
//  Copyright (c) 2014 News Corp. All rights reserved.
//


import Cocoa
import SpriteKit

class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var skView: SKView!
    
    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        /* Pick a size for the scene */


        let scene = GameScene.sceneWithSize(self.skView!.bounds.size)

        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        
        self.skView!.presentScene(scene)
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        self.skView!.ignoresSiblingOrder = true
        
        self.skView!.showsFPS = true
        self.skView!.showsNodeCount = true
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true;
    }
}
