//
//  ContactDelegate.swift
//  TimeWaster
//
//  Created by Dorothy Luetz on 11/5/23.
//

import SceneKit

class ContactDelegate: NSObject, SCNPhysicsContactDelegate {
    var onBegin: ((SCNPhysicsContact) -> ())? = nil
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        onBegin?(contact)
    }
}
class SceneRendererDelegate: NSObject, SCNSceneRendererDelegate {
  var renderer: SCNSceneRenderer?
  var onEachFrame: (() -> ())? = nil

  func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
    if self.renderer == nil {
      self.renderer = renderer
      let type = type(of: renderer)

      print("HAHA GOT 'EM STUPID MACHINE! We got SceneRenderer: \(type)")
    }

    onEachFrame?()
  }
}
