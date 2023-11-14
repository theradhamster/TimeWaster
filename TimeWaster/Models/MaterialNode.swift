//
//  MaterialNode.swift
//  TimeWaster
//
//  Created by Dorothy Luetz on 11/5/23.
//

import SwiftUI
import SceneKit

class MaterialNode: SCNNode {
    var type: EntityType
    var gameID: String!
    init (type: EntityType, id: String? = nil) {
        self.type = type
        if id != nil {
            self.gameID = id
        }
        super.init()
        name = "Material Node (\(type)\(self.gameID ?? ""))"
    }
    required init?(coder Decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
let bigBallNode = { (image: UIImage) -> MaterialNode in
    let sphereGeometry = SCNSphere(radius: 1)
    sphereGeometry.segmentCount = 10
    var uuid = UUID.short()
    for material in sphereGeometry.materials {
        material.diffuse.contents = image
    }
    let node = defaultHeroNode()
    node.gameID = uuid
    node.geometry = sphereGeometry
    return node
}
let bigCubeNode = { (color: Color) -> MaterialNode in
  var box = SCNBox()
  let cellSize: CGFloat = FieldConstants.defaultCellSize
    var uuid = UUID.short()
  box = SCNBox(
    width: cellSize * 0.4,
    height: cellSize,
    length: cellSize * 0.4,
    chamferRadius: 0)
  uuid.append("-big")
  for material in box.materials {
    material.diffuse.contents = color.cgColor
  }
  let node = defaultHeroNode()
  node.gameID = uuid
  node.geometry = box
  return node
}
let regularCubeNode = { (image: UIImage) -> MaterialNode in
  var box = SCNBox()
  let cellSize: CGFloat = FieldConstants.defaultCellSize
    var uuid = UUID.short()
  box = SCNBox(
    width: cellSize * 0.4,
    height: cellSize * 0.9,
    length: cellSize * 0.4,
    chamferRadius: 0)
  for material in box.materials {
    material.diffuse.contents = image
  }
  let node = defaultHeroNode()
  node.gameID = uuid
  node.geometry = box
  return node
}
let smallCubeNode = { (color: Color) -> MaterialNode in
  var box = SCNBox()
  let cellSize: CGFloat = FieldConstants.defaultCellSize
    var uuid = UUID.short()
  box = SCNBox(
    width: cellSize * 0.2,
    height: cellSize * 0.8,
    length: cellSize * 0.2,
    chamferRadius: 0)
  for material in box.materials {
    material.diffuse.contents = color.cgColor
  }
  let node = defaultHeroNode()
  node.gameID = uuid
  node.geometry = box
  return node
}
let defaultHeroNode = { () -> MaterialNode in
  let node = MaterialNode(type: .hero)
  node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
  node.physicsBody?.mass = 4
  node.physicsBody?.restitution = 0
  node.physicsBody?.categoryBitMask = EntityType.hero.rawValue
  node.physicsBody?.collisionBitMask = EntityType.hero.rawValue | EntityType.field.rawValue
  node.physicsBody?.contactTestBitMask = EntityType.hero.rawValue | EntityType.platform.rawValue
  return node
}

