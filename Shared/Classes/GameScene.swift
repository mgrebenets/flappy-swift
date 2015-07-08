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
        var localizedName: String {
            switch self {
            case .Ready: return NSLocalizedString("Ready", comment: "Ready")
            case .Flying: return NSLocalizedString("Flying", comment: "Flying")
            case .Dying: return NSLocalizedString("Dying", comment: "Dying")
            case .Over: return NSLocalizedString("Over", comment: "Over")
            }
        }
    }

    let swift = Swift()
    var state: State = .Ready

    // free fall
    class var gravityDirection:CGFloat { return 1.0 }
    let vy: CGFloat = gravityDirection * 12.0   // velocity
    var y0: CGFloat = 0     // vertical offset
    let g: CGFloat = gravityDirection * 9.8 * 0.1  // gravity
    var t: CGFloat = 0   // time

    func freeFall() -> CGFloat {
        // free fall equation
        return y0 + vy * t - g * pow(t, 2) / 2
    }

    var pipesBuffer = RingBuffer<Pipe>()
    let vx: CGFloat = 2.0
    var pipeWidth: CGFloat = 100.0
    var minPipeDistance: CGFloat = 150

    func randomOffsetRatio() -> CGFloat {
        return 0.2 + CGFloat(drand48()) / 3.0
    }

    func randomGapRatio() -> CGFloat {
        return 0.25 + CGFloat(drand48()) / 10.0
    }

    func randomPipePositionWithOffset(offset: CGFloat) -> CGPoint {
        return CGPointMake(offset + minPipeDistance + CGFloat(arc4random_uniform(50)), 0)
    }

    override init(size: CGSize) {
        super.init(size: size)


        // Seed the rands
        let p: UnsafeMutablePointer<time_t> = nil
        srand48(Int(time(p)))

        backgroundColor = SKColor.grayColor()
        swift.setScale(0.1)
        addChild(swift)

        // 4 pipes
        pipesBuffer.add(Pipe())
        pipesBuffer.add(Pipe())
        pipesBuffer.add(Pipe())
        pipesBuffer.add(Pipe())

        for pipe in pipesBuffer.items {
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

        pipesBuffer.reset()
        var offset = frame.size.width
        for (_, pipe) in pipesBuffer.items.enumerate() {
            pipe.size = CGSizeMake(pipeWidth, frame.height)
            pipe.offsetRatio = randomOffsetRatio()
            pipe.gapRatio = randomGapRatio()
            pipe.layout()
            pipe.position = randomPipePositionWithOffset(offset)
            offset = pipe.position.x + pipeWidth
        }
    }

    func kill() {
        state = .Dying
        swift.die { [unowned self] in
            self.end()
        }
    }

    func end() {
        // game over
        state = .Over
    }

    #if os(iOS)
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        handleTouch()
    }
    #else
    override func mouseDown(theEvent: NSEvent) {
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

        // collision test with walls
        for pipe in pipesBuffer.items {
            if pipe ❌ swift.calculateAccumulatedFrame() {
                kill()
                return
            }
        }

        // move pipes
        for pipe in pipesBuffer.items {
            pipe.position.x -= vx
        }

        // move swift
        swift.position.y = freeFall()
        t++

        updatePipes()
    }

    func updatePipes() {

        if pipesBuffer.first!.offscreenLeft {
            // reuse first pipe in buffer
            let pipe = pipesBuffer.first!
            pipe.offsetRatio = randomOffsetRatio()
            pipe.gapRatio = randomGapRatio()
            pipe.layout()
            pipe.position = randomPipePositionWithOffset(pipesBuffer.last!.position.x + pipeWidth)

            // shift the ring
            pipesBuffer.shift()

        }
    }

}
