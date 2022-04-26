//
//  PaletteModel.swift
//  Ant App
//
//  Created by Eugenio Raja on 20/04/22.
//

import Foundation
import SwiftUI

class Palette {
    public var palette: (Double, Double, Double)
    
    let possiblePalette = [
        (0.8, 0.3, 0.3),
        (0.3, 0.8, 0.3),
        (0.3, 0.3, 0.8),
        (0.6, 0.6, 0.2),
        (0.2, 0.6, 0.6),
        (0.6, 0.2, 0.6),
        (0.8, 0.8, 0.8)
    ]
    
    init() {
        self.palette = self.possiblePalette.randomElement()!
    }
    
    func getColors(_ palette: Palette) -> (Double, Double, Double) {
        return (palette.palette.0, palette.palette.1, palette.palette.2)
    }
}
