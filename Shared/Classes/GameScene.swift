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

    // free fall
    let vy: CGFloat = 12.0   // velocity
    var y0: CGFloat = 0     // vertical offset
    let g: CGFloat = 9.8 * 0.1  // gravity
    var t: CGFloat = 0   // time

    func freeFall() -> CGFloat {
        // free fall equation
        return y0 + vy * t - g * pow(t, 2) / 2
    }

    var pipes = [Pipe]()
    let vx: CGFloat = 2.0

    override init(size: CGSize) {
        super.init(size: size)


        // seed the rands
        var p: UnsafeMutablePointer<time_t> = nil
        srand48(Int(time(p)))

        backgroundColor = SKColor.grayColor()
        swift.setScale(0.1)
        addChild(swift)

        pipes = [Pipe(), Pipe(), Pipe(), Pipe()]    // 4  pipes
        for pipe in pipes {
            addChild(pipe)
        }
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
        swift.position = CGPointMake(view!.bounds.width * 0.1, view!.bounds.size.height / 2)
        y0 = swift.position.y
        t = 0

        var pipeWidth: CGFloat = 100
        var minPipeDistance: CGFloat = 150
        for (index, pipe) in enumerate(pipes) {
            pipe.size = CGSizeMake(pipeWidth, frame.height)
            pipe.offsetRatio = 0.2 + CGFloat(drand48()) / 3.0
            pipe.gapRatio = 0.25 + CGFloat(drand48()) / 10.0
            pipe.layout()
            pipe.position = CGPointMake(frame.size.width + CGFloat(index) * (pipeWidth + minPipeDistance + CGFloat(arc4random_uniform(50))), 0)
        }
    }

    func kill() {
        state = .Dying
        swift.die {
            self.end()
        }
    }

    func end() {
        // game over
        state = .Over
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
        // flap
        y0 = swift.position.y
        t = 0
    }

    // MARK: Update
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if state != .Flying {
            return
        }

        // check fall down (simplified)
        if swift.position.y - swift.calculateAccumulatedFrame().size.height / 2 <= 0 {
            kill()
            return
        }

        // move pipe
        for pipe in pipes {
            pipe.position.x -= vx
        }

        // move swift
        swift.position.y = freeFall()
        t += 1
    }

}
