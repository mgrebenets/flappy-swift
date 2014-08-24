//
//  Swift.swift
//  FlappySwift
//
//  Created by Grebenets, Maksym on 8/24/14.
//  Copyright (c) 2014 News Corp. All rights reserved.
//

import SpriteKit

class Swift: SKNode {
    var bird: SKSpriteNode
    override init() {
        bird = SKSpriteNode(imageNamed: "Swift")
        super.init()
        addChild(bird)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
