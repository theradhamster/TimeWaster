//
//  FlappyGame.swift
//  TimeWaster
//
//  Created by Dorothy Luetz on 12/1/23.
//

import SpriteKit

enum GameState {
    case showingLogo, playing, dead
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "SCORE: \(score)"
        }
    }
    var backgroundMusic: SKAudioNode!
    var logo: SKSpriteNode!
    var gameOver: SKSpriteNode!
    var gameState = GameState.showingLogo
    let rockTexture = SKTexture(imageNamed: "spikesstretched")
    let explosion = SKEmitterNode(fileNamed: "PlayerExplosion")
    
    override func didMove(to view: SKView) {
        createPlayer()
        createSky()
        createBackground()
        createFog()
        createGround()
        createScore()
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
        physicsWorld.contactDelegate = self
        if let musicURL = Bundle.main.url(forResource: "hellsounds", withExtension: "wav") {
            backgroundMusic = SKAudioNode(url: musicURL)
            addChild(backgroundMusic)
        }
        createLogos()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameState {
        case .showingLogo:
            gameState = .playing
            let fadeOut = SKAction.fadeOut(withDuration: 0.5)
            let remove = SKAction.removeFromParent()
            let wait = SKAction.wait(forDuration: 0.5)
            let activatePlayer = SKAction.run { [unowned self] in
                self.player.physicsBody?.isDynamic = true
                self.startRocks()
            }
            let sequence = SKAction.sequence([fadeOut, wait, activatePlayer, remove])
            logo.run(sequence)
        case .playing:
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 50))
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        case .dead:
            if let scene = GameScene(fileNamed: "GameScene") {
                scene.scaleMode = .aspectFill
                let transition = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 1)
                view?.presentScene(scene, transition: transition)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard player != nil else { return }
        let value = player.physicsBody!.velocity.dy * 0.001
        let rotate = SKAction.rotate(toAngle: value, duration: 0.1)
        player.run(rotate)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "scoreDetect" || contact.bodyB.node?.name == "scoreDetect" {
            if contact.bodyA.node == player {
                contact.bodyB.node?.removeFromParent()
            } else {
                contact.bodyA.node?.removeFromParent()
            }
            let sound = SKAction.playSoundFileNamed("fart.mp3", waitForCompletion: false)
            run(sound)
            score += 1
            return
        }
        guard contact.bodyA.node != nil && contact.bodyB.node != nil else {
            return
        }
        if contact.bodyA.node == player || contact.bodyB.node == player {
            if let explosion = SKEmitterNode(fileNamed: "PlayerExplosion") {
                explosion.position = player.position
                addChild(explosion)
            }
            let sound = SKAction.playSoundFileNamed("demonlaugh.wav", waitForCompletion: false)
            run(sound)
            gameOver.alpha = 1
            gameState = .dead
                        backgroundMusic.run(SKAction.stop())
            player.removeFromParent()
            speed = 0
        }
    }
    
    func createPlayer() {
        let playerTexture = SKTexture(imageNamed: "devilme")
        player = SKSpriteNode(texture: playerTexture)
        player.zPosition = 10
        player.position = CGPoint(x: frame.width / 6, y: frame.height * 0.5)
        addChild(player)
        player.physicsBody = SKPhysicsBody(texture: playerTexture, size: playerTexture.size())
        player.physicsBody!.contactTestBitMask = player.physicsBody!.collisionBitMask
        player.physicsBody?.isDynamic = false
        player.physicsBody?.collisionBitMask = 0
        let frame2 = SKTexture(imageNamed: "devilme")
        let frame3 = SKTexture(imageNamed: "devilme")
        let animation = SKAction.animate(with: [playerTexture, frame2, frame3, frame2], timePerFrame: 0.01)
        let runForever = SKAction.repeatForever(animation)
        player.run(runForever)
    }
    
    func createSky() {
        let topSky = SKSpriteNode(color: UIColor(hue: 0.98, saturation: 1.00, brightness: 0.40, alpha: 1), size: CGSize(width: frame.width, height: frame.height * 0.55))
        topSky.anchorPoint = CGPoint(x: 0.5, y: 1)
        let bottomSky = SKSpriteNode(color: UIColor(hue: 0.98, saturation: 2.00, brightness: 0.10, alpha: 1), size: CGSize(width: frame.width, height: frame.height * 0.45))
        bottomSky.anchorPoint = CGPoint(x: 0.5, y: 1)
        topSky.position = CGPoint(x: frame.midX, y: frame.height)
        bottomSky.position = CGPoint(x: frame.midX, y: bottomSky.frame.height)
        addChild(topSky)
        addChild(bottomSky)
        bottomSky.zPosition = -40
        topSky.zPosition = -40
    }
    
    func createBackground() {
        let backgroundTexture = SKTexture(imageNamed: "hellcavernresized")
        for i in 0 ... 1 {
            let background = SKSpriteNode(texture: backgroundTexture)
            background.zPosition = -30
            background.anchorPoint = CGPoint.zero
            background.position = CGPoint(x: (backgroundTexture.size().width * CGFloat(i)) - CGFloat(1 * i), y: 100)
            addChild(background)
            let moveLeft = SKAction.moveBy(x: -backgroundTexture.size().width, y: 0, duration: 20)
            let moveReset = SKAction.moveBy(x: backgroundTexture.size().width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            background.run(moveForever)
        }
    }
    
    func createGround() {
        let groundTexture = SKTexture(imageNamed: "groundresized")
        for i in 0 ... 1 {
            let ground = SKSpriteNode(texture: groundTexture)
            ground.zPosition = -10
            ground.position = CGPoint(x: (groundTexture.size().width / 2.0 + (groundTexture.size().width * CGFloat(i))), y: groundTexture.size().height / 3)
            ground.physicsBody = SKPhysicsBody(texture: ground.texture!, size: ground.texture!.size())
            ground.physicsBody?.isDynamic = false
            addChild(ground)
            let moveLeft = SKAction.moveBy(x: -groundTexture.size().width, y: 0, duration: 5)
            let moveReset = SKAction.moveBy(x: groundTexture.size().width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            ground.run(moveForever)
        }
    }
    
    func createFog() {
        let cloudTexture = SKTexture(imageNamed: "cloudred")
        let fireTexture = SKTexture(imageNamed: "firemedium")
        for i in 0 ... 1 {
            let cloud = SKSpriteNode(texture: cloudTexture)
            cloud.zPosition = -18
            cloud.anchorPoint = CGPoint.zero
            cloud.position = CGPoint(x: (cloudTexture.size().width * CGFloat(i)) - CGFloat(1 * i), y: 300)
            addChild(cloud)
            let moveLeft = SKAction.moveBy(x: -cloudTexture.size().width, y: 0, duration: 9)
            let moveReset = SKAction.moveBy(x: cloudTexture.size().width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            cloud.run(moveForever)
        }
        for i in 0 ... 1 {
            let cloud2 = SKSpriteNode(texture: cloudTexture)
            cloud2.zPosition = -13
            cloud2.anchorPoint = CGPoint.zero
            cloud2.position = CGPoint(x: (cloudTexture.size().width * CGFloat(i)) - CGFloat(1 * i), y: 230)
            addChild(cloud2)
            let moveRight = SKAction.moveBy(x: -cloudTexture.size().width, y: 0, duration: 6)
            let moveReset = SKAction.moveBy(x: cloudTexture.size().width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveRight, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            cloud2.run(moveForever)
        }
        for i in 0 ... 1 {
            let fire = SKSpriteNode(texture: fireTexture)
            fire.zPosition = -15
            fire.anchorPoint = CGPoint.zero
            fire.position = CGPoint(x: (fireTexture.size().width * CGFloat(i)) - CGFloat(1 * i), y: 100)
            addChild(fire)
            let moveRight = SKAction.moveBy(x: -fireTexture.size().width, y: 0, duration: 6)
            let moveReset = SKAction.moveBy(x: fireTexture.size().width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveRight, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            fire.run(moveForever)
        }
    }
    
    func createRocks() {
        let rockTexture = SKTexture(imageNamed: "spikelessbig")
        let topRock = SKSpriteNode(texture: rockTexture)
        topRock.physicsBody = SKPhysicsBody(texture: rockTexture, size: rockTexture.size())
        topRock.physicsBody?.isDynamic = false
        topRock.zRotation = .pi
        topRock.xScale = -1.0
        let bottomRock = SKSpriteNode(texture: rockTexture)
        bottomRock.physicsBody = SKPhysicsBody(texture: rockTexture, size: rockTexture.size())
        bottomRock.physicsBody?.isDynamic = false
        topRock.zPosition = -13
        bottomRock.zPosition = -13
        let rockCollision = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 32, height: frame.height))
        rockCollision.physicsBody = SKPhysicsBody(rectangleOf: rockCollision.size)
        rockCollision.physicsBody?.isDynamic = false
        rockCollision.name = "scoreDetect"
        addChild(topRock)
        addChild(bottomRock)
        addChild(rockCollision)
        let xPosition = frame.width + topRock.frame.width
        let max = CGFloat(frame.height / 3)
        let yPosition = CGFloat.random(in: -50...max)
        let rockDistance: CGFloat = 70
        topRock.position = CGPoint(x: xPosition, y: yPosition + topRock.size.height + rockDistance)
        bottomRock.position = CGPoint(x: xPosition, y: yPosition - rockDistance)
        rockCollision.position = CGPoint(x: xPosition + (rockCollision.size.width * 2), y: frame.midY)
        let endPosition = frame.width + (topRock.frame.width * 2)
        let moveAction = SKAction.moveBy(x: -endPosition, y: 0, duration: 6.2)
        let moveSequence = SKAction.sequence([moveAction, SKAction.removeFromParent()])
        topRock.run(moveSequence)
        bottomRock.run(moveSequence)
        rockCollision.run(moveSequence)
    }
    
    func startRocks() {
        let create = SKAction.run { [unowned self] in
            self.createRocks()
        }
        let wait = SKAction.wait(forDuration: 2.5)
        let sequence = SKAction.sequence([create, wait])
        let repeatForever = SKAction.repeatForever(sequence)
        run(repeatForever)
    }
    
    func createScore() {
        scoreLabel = SKLabelNode(fontNamed: "CHILLER")
        scoreLabel.fontSize = 32
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 150)
        scoreLabel.text = "SCORE: 0"
        scoreLabel.fontColor = UIColor.white
        addChild(scoreLabel)
    }
    
    func createLogos() {
        logo = SKSpriteNode(imageNamed: "thomlogo")
        logo.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(logo)
        gameOver = SKSpriteNode(imageNamed: "devilmediumlogo")
        gameOver.position = CGPoint(x: frame.midX, y: frame.midY)
        gameOver.alpha = 0
        addChild(gameOver)
    }

}

