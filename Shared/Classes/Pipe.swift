//
//  Pipe.swift
//  FlappySwift
//
//  Created by Grebenets, Maksym on 8/25/14.
//  Copyright (c) 2014 News Corp. All rights reserved.
//

import SpriteKit

class Pipe: SKNode {
    var size: CGSize
    var offsetRatio: CGFloat
    var gapRatio: CGFloat
    private var top, bottom: SKSpriteNode

    init(size: CGSize, offsetRatio: CGFloat, gapRatio: CGFloat = 0.3) {
        self.size = size
        self.offsetRatio = offsetRatio
        self.gapRatio = gapRatio
        bottom = SKSpriteNode(imageNamed: "Pipe")
        top = SKSpriteNode(imageNamed: "Pipe")
        super.init()

        // center rect for scaling
        bottom.centerRect = CGRectMake(0.4, 0.4, 0.1, 0.1)
        top.centerRect = CGRectMake(0.4, 0.4, 0.1, 0.1)

        top.zRotation = CGFloat(M_PI)    // rotate top 180 degrees

        // anchor points
        bottom.anchorPoint = CGPointZero
        top.anchorPoint = CGPointMake(1, 1)

        addChild(bottom)
        addChild(top)

        layout()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func layout() {
        // TODO: layout

        bottom.size = CGSizeMake(size.width, size.height * offsetRatio)
        top.size = CGSizeMake(size.width, size.height * (1 - offsetRatio - gapRatio))

        bottom.position = CGPointZero
        top.position = CGPointMake(0, size.height * (offsetRatio + gapRatio))

    }
}
