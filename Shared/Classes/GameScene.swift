//
//  GameScene.swift
//  FlappySwift
//
//  Created by Grebenets, Maksym on 8/24/14.
//  Copyright (c) 2014 News Corp. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    enum State {
        case Ready, Flying, Dying, Over
    }

    let swift = Swift()
    var state = State.Ready

    override init(size: CGSize) {
        super.init(size: size)

        backgroundColor = SKColor.whiteColor()
        swift.setScale(0.1)
        addChild(swift)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        start()
    }

    func start() {
        state = .Ready
        swift.position = CGPointMake(view.bounds.width * 0.1, view.bounds.size.height / 2)
    }

    #if os(iOS)
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        handleTouch()
    }
    #else
    override func mouseDown(theEvent: NSEvent!) {
        handleTouch()
    }
    #endif

    // MARK: Touch Handling
    func handleTouch() {
        switch state {
        case .Ready:
            fly()
        case .Flying:
            flap()
        case .Dying:
            // ignore touches
            break
        case .Over:
            start()
        }
    }

    // MARK: Kinematics
    func fly() {
        state = .Flying
    }

    func flap() {
        // TODO: flap
    }

    // MARK: Update
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }

}
