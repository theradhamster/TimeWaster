//
//  TestJump.swift
//  TimeWaster
//
//  Created by Dorothy Luetz on 11/5/23.
//

import SceneKit
import AVFoundation
import SwiftUI

fileprivate let GRAVITY: Float = 20
fileprivate let JUMP_FORCE: Float = 25
fileprivate let CAMERA_FOV: CGFloat = 40
fileprivate let FIELD_SIZE: Int = 5
fileprivate let CELL_SIZE: CGFloat = 5
fileprivate let CAMERA_HEIGHT: Float = 30

@MainActor class JumpGame: ObservableObject {
    @Published var gameOver: Bool = false
    @Published var gameIsShowing = false
    var scene: SCNScene = SCNScene()
    var player: AVAudioPlayer?
    let contactDelegate = ContactDelegate()
    @Published var score: Int = 0
    var ballNode = bigBallNode(UIImage(named: "walterwhite")!)
    var currentField: Field
    var platforms: [SCNNode] = []
    var sceneRendererDelegate = SceneRendererDelegate()
    private let cameraNode: SCNNode = SCNNode()
    private var lastOffset: Double = 0
    
    init() {
        scene.physicsWorld.gravity = SCNVector3(0, -GRAVITY, 0)
        scene.background.contents = UIImage(named: "email")
        currentField = Field(size: FIELD_SIZE, cellSize: CELL_SIZE)
        currentField.node.eulerAngles = SCNVector3(Double.pi / 2, 0, Double.pi / 2)
        scene.rootNode.addChildNode(currentField.node)
        scene.rootNode.addChildNode(ballNode)
        scene.physicsWorld.contactDelegate = contactDelegate
        contactDelegate.onBegin = onContactBegin(contact:)
        prepareCamera()
        preparePlayers()
        fill(field: currentField)
    }
    func onEachFrame() {
        let ballPosition = ballNode.presentation.position
        let cameraOffset = SCNVector3(0, CAMERA_HEIGHT, CAMERA_HEIGHT)
        cameraNode.position = ballPosition + cameraOffset
        cameraNode.look(at: ballPosition)
        if let velocity = ballNode.physicsBody?.velocity {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 1
            let newFOV = CAMERA_FOV + CGFloat(velocity.y)
            cameraNode.camera?.fieldOfView = newFOV
            SCNTransaction.commit()
        }
        changeScore(value: Int(ballNode.presentation.worldPosition.y))
        if ballNode.presentation.worldPosition.y > currentField.centerCell().node.presentation.worldPosition.y {
            let newField = addField(above: currentField)
            fill(field: newField)
            currentField = newField
        }
        if ballPosition.y < -10 {
            Task {
                gameOver = true
            }
        }
    }
    func onControlChange(newValue: Double) {
        ballNode.physicsBody?.applyForce(SCNVector3(newValue / 3 - lastOffset, 0, 0), asImpulse: true)
        lastOffset = newValue / 3
    }
    func onControlEnd() {
        lastOffset = 0
    }
    func doNewGame() {
        ballNode = bigBallNode(UIImage(named: "walterwhite")!)
            score = 0
            scene.physicsWorld.gravity = SCNVector3(0, -GRAVITY, 0)
            scene.background.contents = UIImage(named: "email")
            currentField = Field(size: FIELD_SIZE, cellSize: CELL_SIZE)
            currentField.node.eulerAngles = SCNVector3(Double.pi / 2, 0, Double.pi / 2)
            scene.rootNode.addChildNode(currentField.node)
            scene.rootNode.addChildNode(ballNode)
            scene.physicsWorld.contactDelegate = contactDelegate
            contactDelegate.onBegin = onContactBegin(contact:)
            prepareCamera()
            preparePlayers()
            fill(field: currentField)
        Task {
            gameOver = false
        }
    }
}
private extension JumpGame {
    func prepareCamera() {
        cameraNode.name = "CameraHuyamera"
        cameraNode.camera = SCNCamera()
        cameraNode.eulerAngles = SCNVector3(Float.pi / -3, 0, 0)
        cameraNode.camera?.fieldOfView = CAMERA_FOV
        cameraNode.camera?.automaticallyAdjustsZRange = true
        scene.rootNode.addChildNode(cameraNode)
    }
    func preparePlayers() {
        let fieldCellForBall = currentField.fieldCell(in: currentField.size / 2, column: 1)!
        ballNode.position = fieldCellForBall.node.worldPosition + SCNVector3(x: 0, y: 0, z: 3)
        ballNode.physicsBody?.applyForce(SCNVector3(x: 0, y: JUMP_FORCE * 2, z: 0), asImpulse: true)
    }
}
private extension JumpGame {
    func onContactBegin(contact: SCNPhysicsContact) {
        let nodeA = contact.nodeA
        let nodeB = contact.nodeB
        let ballNode = ballNode
        if let velocity = ballNode.physicsBody?.velocity, velocity.y > 0 {
            return
        }
        if platforms.contains(nodeA) && ballNode.contains(nodeB) {
            changeScore(value: -1)
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            Task {
                playSound()
            }
            nodeB.physicsBody?.velocity.y = JUMP_FORCE
            return
        }
        if platforms.contains(nodeB) && ballNode.contains(nodeA) {
            changeScore(value: -1)
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            Task {
                playSound()
            }
            nodeA.physicsBody?.velocity.y = JUMP_FORCE
            return
        }
    }
    func playSound() {
        Task {
            guard let path = Bundle.main.path(forResource: "jesse", ofType: "mp3") else {
                return }
            let url = URL(fileURLWithPath: path)
            
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, options: AVAudioSession.CategoryOptions.mixWithOthers)
                player = try AVAudioPlayer(contentsOf: url)
                player?.play()
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}
private extension JumpGame {
    func addField(above field: Field) -> Field {
        print("Adding new field above \(field.node.name ?? "<NIL>")")
        let newField = Field(size: FIELD_SIZE, cellSize: CELL_SIZE)
        newField.node.eulerAngles = SCNVector3(Double.pi / 2, 0, Double.pi / 2)
        newField.node.worldPosition.y = field.node.boundingBox.max.z + field.node.presentation.worldPosition.y
        scene.rootNode.addChildNode(newField.node)
        return newField
    }
    func fill(field: Field) {
        (field.size * field.size / 4).times {
            let newPlatform = regularCubeNode(UIImage(named: "areyoustupid")!)
            newPlatform.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
            newPlatform.physicsBody?.categoryBitMask = EntityType.platform.rawValue
            newPlatform.physicsBody?.contactTestBitMask = EntityType.platform.rawValue
            field.put(object: newPlatform, to: field.cells.randomElement()!)
            platforms.append(newPlatform)
        }
    }
}
private extension JumpGame {
    func changeScore(value: Int) {
        if value < score {
            return
        }
        DispatchQueue.main.async {
            self.score = value
        }
    }
}
