//
//  Entity.swift
//  TimeWaster
//
//  Created by Dorothy Luetz on 11/5/23.
//

import Foundation

protocol Entity {
    var node: MaterialNode { get }
}

enum EntityType: Int {
    case field = 1
    case hero
    case shield
    case platform
}
