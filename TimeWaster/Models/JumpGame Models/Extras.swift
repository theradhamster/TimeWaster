//
//  Extras.swift
//  TimeWaster
//
//  Created by Dorothy Luetz on 11/5/23.
//

import SwiftUI
import SceneKit

extension SCNNode {
  
  func height() -> CGFloat {
    return CGFloat(self.boundingBox.max.y - self.boundingBox.min.y)
  }

}
extension UUID {
  static func short() -> String{
    return String(UUID().uuidString.prefix(6))
  }
}
extension Int {
  func times(_ f: () -> ()) {
    if self > 0 {
      for _ in 0..<self {
        f()
      }
    }
  }
  
  func times(_ f: @autoclosure () -> ()) {
    if self > 0 {
      for _ in 0..<self {
        f()
      }
    }
  }
}
extension SCNVector3 {
  static func distanceBetween(vector1: SCNVector3, vector2: SCNVector3) -> Double {
    let vectorBetween = vector1 - vector2
    let length = vectorBetween.length()
    return length
  }

  /**
   * Returns the length (magnitude) of the vector described by the SCNVector3
   */
  func length() -> Double {
    return Double(sqrt(x * x + y * y + z * z))
  }
}

/**
 * Adds two SCNVector3 vectors and returns the result as a new SCNVector3.
 */
func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
  return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}

/**
 * Increments a SCNVector3 with the value of another.
 */
func += ( left: inout SCNVector3, right: SCNVector3) {
  left = left + right
}

/**
 * Subtracts two SCNVector3 vectors and returns the result as a new SCNVector3.
 */
func - (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
  return SCNVector3Make(left.x - right.x, left.y - right.y, left.z - right.z)
}

/**
 * Decrements a SCNVector3 with the value of another.
 */
func -= ( left: inout SCNVector3, right: SCNVector3) {
  left = left - right
}

/**
 * Multiplies two SCNVector3 vectors and returns the result as a new SCNVector3.
 */
func * (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
  return SCNVector3Make(left.x * right.x, left.y * right.y, left.z * right.z)
}

/**
 * Multiplies a SCNVector3 with another.
 */
func *= ( left: inout SCNVector3, right: SCNVector3) {
  left = left * right
}

/**
 * Multiplies the x, y and z fields of a SCNVector3 with the same scalar value and
 * returns the result as a new SCNVector3.
 */
func * (vector: SCNVector3, scalar: Float) -> SCNVector3 {
  return SCNVector3Make(vector.x * scalar, vector.y * scalar, vector.z * scalar)
}

/**
 * Multiplies the x and y fields of a SCNVector3 with the same scalar value.
 */
func *= ( vector: inout SCNVector3, scalar: Float) {
  vector = vector * scalar
}

/**
 * Divides two SCNVector3 vectors abd returns the result as a new SCNVector3
 */
func / (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
  return SCNVector3Make(left.x / right.x, left.y / right.y, left.z / right.z)
}

/**
 * Divides a SCNVector3 by another.
 */
func /= ( left: inout SCNVector3, right: SCNVector3) {
  left = left / right
}

/**
 * Divides the x, y and z fields of a SCNVector3 by the same scalar value and
 * returns the result as a new SCNVector3.
 */
func / (vector: SCNVector3, scalar: Float) -> SCNVector3 {
  return SCNVector3Make(vector.x / scalar, vector.y / scalar, vector.z / scalar)
}

/**
 * Divides the x, y and z of a SCNVector3 by the same scalar value.
 */
func /= ( vector: inout SCNVector3, scalar: Float) {
  vector = vector / scalar
}
struct MaterialButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .foregroundColor(.primary)
      .padding()
      .background(.ultraThinMaterial)
      .cornerRadius(25)
      .scaleEffect(configuration.isPressed ? 0.9 : 1)
      .hoverEffect(.lift)
  }
}
struct YesButton: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .foregroundColor(.green)
      .padding()
      .background(.ultraThinMaterial)
      .cornerRadius(25)
      .scaleEffect(configuration.isPressed ? 0.9 : 1)
      .hoverEffect(.lift)
  }
}
struct NoButton: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .foregroundColor(.red)
      .padding()
      .background(.ultraThinMaterial)
      .cornerRadius(25)
      .scaleEffect(configuration.isPressed ? 0.9 : 1)
      .hoverEffect(.lift)
  }
}
struct Heart: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY ))
        path.addCurve(to: CGPoint(x: rect.minX, y: rect.height/4), control1:CGPoint(x: rect.midX, y: rect.height*3/4), control2: CGPoint(x: rect.minX, y: rect.midY))
        path.addArc(center: CGPoint( x: rect.width/4,y: rect.height/4), radius: (rect.width/4), startAngle: Angle(radians: Double.pi), endAngle: Angle(radians: 0), clockwise: false)
        path.addArc(center: CGPoint( x: rect.width * 3/4,y: rect.height/4), radius: (rect.width/4), startAngle: Angle(radians: Double.pi), endAngle: Angle(radians: 0), clockwise: false)
        path.addCurve(to: CGPoint(x: rect.midX, y: rect.height), control1: CGPoint(x: rect.width, y: rect.midY), control2: CGPoint(x: rect.midX, y: rect.height*3/4))
        return path
    }
}
