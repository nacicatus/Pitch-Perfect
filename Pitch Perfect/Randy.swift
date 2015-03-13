//
//  Randy.swift
//  Pitch Perfect
//
//  Created by Saurabh Sikka on 13/03/15.
//  Copyright (c) 2015 Saurabh Sikka. All rights reserved.
//

import Foundation

protocol RandomNumberGenerator {
    ​    ​func​ ​random​() -> ​Double
    ​}

class Dice {
    let generator: RandomNumberGenerator!
    
}