//
//  VerbCubeXYZ.swift
//  VerbCubeXYZ
//
//  Created by Charles Diggins on 2/16/22.
//

import Foundation

enum VerbCubeDimension : String {
    case Verb
    case Tense
    case Person
}

struct VerbCubeXYZ {
    private let x : VerbCubeDimension
    private let y : VerbCubeDimension
    private let z : VerbCubeDimension
    
    init(x: VerbCubeDimension, y: VerbCubeDimension, z: VerbCubeDimension){
        self.x = x
        self.y = y
        self.z = z
    }
    
    init(){
        self.x = .Person
        self.y = .Tense
        self.z = .Verb
    }
    
    func getXPlane()->VerbCubeDimension{
       return x
    }
    func getYPlane()->VerbCubeDimension{
       return y
    }
    func getZPlane()->VerbCubeDimension{
       return z
    }
}
