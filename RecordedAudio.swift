//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Saurabh Sikka on 10/03/15.
//  Copyright (c) 2015 Saurabh Sikka. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    // create 2 variables. We don't need to set them as optionals because we're
    // going to initialize them below
    var filePathUrl: NSURL
    var title: String
    
    // initialize variables using a constructor
    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}