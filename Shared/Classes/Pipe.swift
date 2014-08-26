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
    private var texture: SKTexture

    var offscreenLeft: Bool {
        return position.x + size.width <= 0
    }

    init(size: CGSize = CGSizeZero, offsetRatio: CGFloat = 0.0, gapRatio: CGFloat = 0.0) {
        self.size = size
        self.offsetRatio = offsetRatio
        self.gapRatio = gapRatio
        texture = SKTexture(imageNamed: "Pipe")
        bottom = SKSpriteNode(texture: texture)
        top = SKSpriteNode(texture: texture)
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

//        bottom.xScale = size.width / texture.size().width
//        bottom.yScale = (size.height * offsetRatio) / texture.size().height

        bottom.size = CGSizeMake(size.width, size.height * offsetRatio)
        top.size = CGSizeMake(size.width, size.height * (1 - offsetRatio - gapRatio))

        bottom.position = CGPointZero
        top.position = CGPointMake(0, size.height * (offsetRatio + gapRatio))

    }

    func hitTest(rect: CGRect) -> Bool {
        var topRect = CGRectOffset(top.frame, position.x, position.y)
        var bottomRect = CGRectOffset(bottom.frame, position.x, position.y)
        return CGRectIntersectsRect(rect, topRect) || CGRectIntersectsRect(rect, bottomRect)
            || (rect.origin.y >= size.height && rect.origin.x + rect.size.width >= position.x && rect.origin.x <= position.x + size.width)
    }
}

infix operator ❌ { associativity left precedence 160 }
func ❌ (pipe: Pipe, rect: CGRect) -> Bool {
    return pipe.hitTest(rect)
}
