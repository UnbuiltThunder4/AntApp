//
//  File.swift
//  
//
//  Created by Eugenio Raja on 06/04/22.
//

import Foundation
import SwiftUI

class TrailPoint: Identifiable, ObservableObject {
    public let id = UUID()
    
    public var pos: Position
    public var index: Int
    
    private var of: Ant
    
    init(of: Ant, x: Int, y: Int) {
        self.of = of
        self.index = of.trail.count
        self.pos = Position(x: x, y: y)
    }
    
    init(of: Ant, pos: Position) {
        self.of = of
        self.index = of.trail.count
        self.pos = Position(x: pos.x, y: pos.y)
    }
    
    func adjustIndexes() {
        self.index -= 1
    }
}

class Ant: Identifiable, ObservableObject {
    public let id = UUID()
    
    @Published public var pos: Position
    @Published public var des: Position?
    @Published public var trail: [TrailPoint] = []
    public var angle: Int
    public var isFollowing: Bool = false
    public var color: Color
    
    private var count: Int = 0
    
    private let maxX = Int(UIScreen.main.bounds.width * 0.5)
    private let maxY = Int(UIScreen.main.bounds.height * 0.5)
    
    init(angle: Int, palette: Palette) {
        self.pos = Position(x: 0, y: 0)
        self.des = nil
        self.angle = angle
        self.trail = []
        let p = palette.getColors(palette)
        self.color = Color(
            red: p.0 + [0.0, 0.1, -0.1].randomElement()!,
            green: p.1 + [0.0, 0.1, -0.1].randomElement()!,
            blue: p.2 + [0.0, 0.1, -0.1].randomElement()!)
    }
    
    public func update(tapped: Position?) {
        
        if (self.trail.count > 20) {
            for trail in self.trail {
                trail.adjustIndexes()
            }
            self.trail.remove(at: 0)
        }
        
        if (tapped != nil) {
            let tapx = tapped!.x - self.maxX
            let tapy = tapped!.y - self.maxY
            
            let tappos = Position(x: tapx, y: tapy)
            self.des = tappos
        }
        else {
            self.des = nil
        }
        
        if (self.des != nil) {
            self.move(target: self.des)
        }
        else {
            self.move(target: nil)
        }
        self.objectWillChange.send()
    }
        
    private func move(target: Position?) {
        self.count += 1
        
        if (self.count % 2 == 0) {
            let trailpoint = TrailPoint(of: self, pos: self.pos)
            self.trail.append(trailpoint)
        }
        
        let offset = [10, 0, -10].randomElement()!
        
        if (self.count % (20 + offset) == 0) {
            self.count -= 20 + offset
            if (Int.random(in: 0..<101)>98) {
                let music = MusicPlayerManager()
                let note = UInt8([58, 62, 65].randomElement()!) + [0, 12].randomElement()!
                music.playNotes(note: note)
            }
        }
        
        var result = Position(x: 0, y: 0)
        
        if (target != nil) {
            var resultangle = self.pos.getDegrees(point: self.des!, origin: self.pos)
            
            if (self.angle > Int(resultangle)) {
                resultangle = Double(self.angle) - ((Double(self.angle) - resultangle) / 2)
            }
            else if (self.angle < Int(resultangle)) {
                resultangle = resultangle - ((resultangle - Double(self.angle)) / 2)
            }
            
            let resultdir = self.pos.getDirectionfromAngle(starting: self.pos, angle: resultangle)
            result = self.pos.oneStepTowards(starting: self.pos, target: resultdir)
        }
        else {
            let resultdir = self.pos.getDirectionfromAngle(starting: self.pos, angle: Double(self.angle))
            result = self.pos.oneStepTowards(starting: self.pos, target: resultdir)
        }
        
        if (result.x < self.maxX && result.x > -self.maxX && result.y < self.maxY && result.y > -self.maxY) {
            self.pos = result
        }
        else {
            while (!(result.x < self.maxX && result.x > -self.maxX && result.y < self.maxY && result.y > -self.maxY)) {
                self.angle = Int.random(in: 0..<360)
                let resultdir = self.pos.getDirectionfromAngle(starting: self.pos, angle: Double(self.angle))
                result = self.pos.oneStepTowards(starting: self.pos, target: resultdir)
            }
        }
    }
}

class Population: ObservableObject {
    @Published public var tapped: Position? = nil
    @Published public var ants: [Ant] = []
    
    public var palette = Palette()
    public var size: Int

    init(size: Int) {
        self.size = size
        self.generate()
    }
    
    func update() {
        self.ants.forEach {
            $0.update(tapped: self.tapped)
        }
    }
    
    public func generate() {
        self.palette = Palette()
        self.ants.removeAll()
        
        var newAnts: [Ant] = []
        for i in 0..<size {
            let ant = Ant(angle: i % 360, palette: self.palette)
            newAnts.append(ant)
        }
        self.ants.append(contentsOf: newAnts)
    }
}
