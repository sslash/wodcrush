#!/usr/bin/swift
import Foundation

let a = "Kettlebell Front Rack Walking Lunge 10-10-10-10\n\nUse the heaviest weight you can for each set.\nRest as needed between sets."

let newlineChars = NSCharacterSet.newlines
        let lineArray = a.components(separatedBy: newlineChars).filter{!$0.isEmpty}

for arr in lineArray {
    print(arr)
}
