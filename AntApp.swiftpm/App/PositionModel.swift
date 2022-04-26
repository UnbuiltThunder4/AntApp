//
//  File.swift
//  
//
//  Created by Eugenio Raja on 06/04/22.
//

import Foundation

class Position: ObservableObject {
    @Published public var x: Int
    @Published public var y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    init(position: Position) {
        self.x = position.x
        self.y = position.y
    }
    
    init(position: Position, offsetx: Int, offsety: Int) {
        self.x = position.x + offsetx
        self.y = position.y + offsety
    }
    
    func getDistance(_ other: Position) -> Float {
        let diffx = Float(self.x - other.x)
        let diffy = Float(self.y - other.y)

        return sqrt((diffx * diffx) + (diffy * diffy))
    }
    
    func getDegrees(point: Position, origin: Position) -> Double {
        let deltaX = point.x - origin.x
        let deltaY = point.y - origin.y
        let radians = atan2(Double(deltaX), Double(deltaY))
        let degrees = radians * (180.0 / Double.pi)
        
        guard degrees < 0 else {
            return degrees
        }
        
        return degrees + 360.0
    }
    
    func getDirectionfromAngle(starting: Position, angle: Double) -> Position {
        let mod = Int(angle) % 12
        var x: Int = 0
        var y: Int = 0
        
        switch mod {
        case 0:
            x = 1
            y = 5
        case 1:
            x = 4
            y = 4
        case 2:
            x = 5
            y = 1
        case 3:
            x = 5
            y = -1
        case 4:
            x = 4
            y = -4
        case 5:
            x = 1
            y = -5
        case 6:
            x = -1
            y = -5
        case 7:
            x = -4
            y = -4
        case 8:
            x = -5
            y = -1
        case 9:
            x = -5
            y = 1
        case 10:
            x = -4
            y = 4
        case 11:
            x = -1
            y = 5
        default:
            x = 0
            y = 0
        }
        return Position(x: x, y: y)
    }
    
    func getDirection(starting: Position, other: Position) -> Position {
        var diffx: Int = 0
        var diffy: Int = 0
        
        if (other.x < starting.x) {
            diffx = -5
        }
        else if (other.x > starting.x) {
            diffx = 5
        }
        if (other.y < starting.y) {
            diffy = -5
        }
        else if (other.y > starting.y) {
            diffy = 5
        }
        
        return Position(x: diffx, y: diffy)
    }
    
    func oneStepTowards(starting: Position, target: Position) -> Position {
        return Position(position: starting, offsetx: target.x, offsety: target.y)
    }
}
