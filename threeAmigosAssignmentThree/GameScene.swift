
//
//  GameScene.swift
//  threeAmigosAssignmentThree
//
//  Created by Hans Soland on 10/13/23.


import SpriteKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    private var player: SKShapeNode!
    private var goal: SKSpriteNode!
    private let motionManager = CMMotionManager()
    
    private var scoreLabel: SKLabelNode!
    private var score: Int = 0

    // collision bit masks
    private struct PhysicsCategory {
        static let Player: UInt32 = 0b1
        static let Goal: UInt32 = 0b10
        static let Border: UInt32 = 0b100
    }

    override func didMove(to view: SKView) {
        self.backgroundColor = .black
        setupNodes()
        setupPhysics()
        
        if motionManager.isGyroAvailable {
            startGyroUpdates()
        }
        
        setupScoreLabel()
    }
        
    func setupScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "Arial")
        scoreLabel.fontSize = 16
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: 180 + scoreLabel.frame.size.width/2, y: size.height - 80)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.text = "Score: \(score)"
        addChild(scoreLabel)
    }

     

    func setupNodes() {
        // circle node for player
        player = SKShapeNode(circleOfRadius: 30)
        player.position = CGPoint(x: size.width/2, y: size.height/2)
        player.fillColor = SKColor.blue
        player.strokeColor = SKColor.blue
        addChild(player)
        
        // square for goal
        goal = SKSpriteNode(color: SKColor.red, size: CGSize(width: 50, height: 50))
        repositionGoal()
        addChild(goal)
    }

    // sets up physics for the game
    func setupPhysics() {
        physicsWorld.contactDelegate = self
        
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.categoryBitMask = PhysicsCategory.Border
        self.physicsBody = borderBody


        // player physics body
        player.physicsBody = SKPhysicsBody(circleOfRadius: 30)
        player.physicsBody?.categoryBitMask = PhysicsCategory.Player // sets player physics
        player.physicsBody?.contactTestBitMask = PhysicsCategory.Goal // sets goal physics
        player.physicsBody?.collisionBitMask = PhysicsCategory.Border // sets border physics
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.restitution = 0.8
        player.physicsBody?.friction = 0.1

        
        player.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 10))
    }

    private var lastAcceleration: CGPoint? // stores last acc value

    // sets up our gyro w/ accelerometer for motion data
    func startGyroUpdates() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1
            motionManager.startAccelerometerUpdates(to: OperationQueue.main) { (data, error) in
                guard let data = data else {
                    print("Error receiving accelerometer data: \(error?.localizedDescription ?? "Unknown error")")
                    return
                } // ensuring data is valid that returned from accelerometer
                
                // extracts raw data and multiplies it to by utilizable for game
                let rawDx = CGFloat(data.acceleration.x) * 500
                let rawDy = CGFloat(data.acceleration.y) * 500
                
                // smoothing alg for raw data
                let smoothingFactor: CGFloat = 0.7
                let smoothedDx = (self.lastAcceleration?.x ?? rawDx) * smoothingFactor + rawDx * (1 - smoothingFactor)
                let smoothedDy = (self.lastAcceleration?.y ?? rawDy) * smoothingFactor + rawDy * (1 - smoothingFactor)
                
                self.player.physicsBody?.velocity = CGVector(dx: smoothedDx, dy: smoothedDy)
                
                // stores previous acceleration for next smoothing
                self.lastAcceleration = CGPoint(x: smoothedDx, y: smoothedDy)
            }
        } else {
            print("Accelerometer is NOT available.") // prints if accelerometer unavailable
        }
    }

    // updates position of square within game
    override func update(_ currentTime: TimeInterval) {
        if player.frame.intersects(goal.frame) {
            playerReachedGoal()
        }
    }

    // updates score and repositions node
    func playerReachedGoal() {
        score += 1
        scoreLabel.text = "Score: \(score)"
        //goal.color = .red // Change color for visual debugging
        repositionGoal()
    }

    // repositions goal node
    func repositionGoal() {
        let randomX = CGFloat(arc4random_uniform(UInt32(size.width - 50))) + 25
        let randomY = CGFloat(arc4random_uniform(UInt32(size.height - 50))) + 25
        goal.position = CGPoint(x: randomX, y: randomY)
    }
}
