//
//  File.swift
//  
//
//  Created by Eugenio Raja on 06/04/22.
//

import Foundation
import SwiftUI

struct AntView: View {
    @ObservedObject var ant: Ant
    let size: CGFloat
    
    init(_ ant: Ant, _ size: CGFloat) {
        self.ant = ant;
        self.size = size
    }
    
    var body: some View {
        return ZStack {
            if (ant.trail.count > 0) {
                ForEach (ant.trail) { trail in
                    let op = (Double(trail.index) / Double(ant.trail.count))
                    let ratio = Double(ant.trail.count) / (Double(trail.index + 4))
                    Circle()
                        .foregroundColor(self.ant.color)
                        .opacity(op * 0.55)
                        .frame(width: self.size * CGFloat(ratio + 0.3), height: self.size * CGFloat(ratio + 0.3))
                        .offset(x: CGFloat(trail.pos.x), y: CGFloat(trail.pos.y))
                }
            }
            Circle()
                .foregroundColor(self.ant.color)
                .frame(width: self.size, height: self.size)
                .offset(x: CGFloat(ant.pos.x), y: CGFloat(ant.pos.y))
        }
    }
}

struct PopulationView: View {
    
    public init() {
        let m = MusicPlayerManager.sharedInstance
    }
    
    let timer = Timer.publish(every: (1.0 / 20.0), on: .main, in: .common).autoconnect()
    
    @ObservedObject var population = Population(size: 75)
    
    var body: some View {
        return ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            ForEach (population.ants) { (ant: Ant) in
                AntView(ant, 10)
            }
        }
        .onTapGesture {
            self.population.generate()
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged({ (value) in
                    self.population.tapped = Position(x: Int(value.location.x), y: Int(value.location.y))
                    })
                .onEnded({ (value) in
                    self.population.tapped = nil
        }))
        .onReceive(timer) { input in
            self.population.update()
        }
    }
}
struct Ant_Previews: PreviewProvider {
    
    static var previews: some View {
       PopulationView()
    }
}
