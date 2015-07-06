//
//  Swift.swift
//  FlappySwift
//
//  Created by Grebenets, Maksym on 8/24/14.
//  Copyright (c) 2014 News Corp. All rights reserved.
//

import SpriteKit

final class Swift: SKNode {
    private let bird: SKSpriteNode
    private var explosion: SKEmitterNode!

    override init() {
        bird = SKSpriteNode(imageNamed: "Swift")
        super.init()
        addChild(bird)

        // add explosion node
        let path = NSBundle.mainBundle().pathForResource("Explosion", ofType: "sks")
        explosion = NSKeyedUnarchiver.unarchiveObjectWithFile(path!) as! SKEmitterNode
        explosion.targetNode = self
        explosion.particleColor = SKColor.redColor()
        explosion.setScale(5)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func die(closure: () -> ()) {
        if explosion.parent == nil {
            addChild(explosion)
        }

        explosion.resetSimulation()

        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(explosion.particleLifetime) * Int64(NSEC_PER_SEC))
        dispatch_after(delay, dispatch_get_main_queue()) {
            self.explosion.removeFromParent()
            closure()
        }
    }
}
