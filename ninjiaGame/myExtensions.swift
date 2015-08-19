//
//  myExtensions.swift
//  ninjiaGame
//
//  Created by Ken Wang on 15/8/18.
//  Copyright (c) 2015年 Ogilvy & Mather RW. All rights reserved.
//

import UIKit

public extension Int {
    /**
    Returns a random integer between 0 and n-1.
    */
    public static func random(n: Int) -> Int {
        return Int(arc4random_uniform(UInt32(n)))
    }
    /**
    Create a random num Int
    :param: lower number Int
    :param: upper number Int
    :return: random number Int
    By DaRkDOG
    */
    public static func random(#min: Int, max: Int) -> Int {
        return Int(arc4random_uniform(UInt32(max - min + 1))) + min
    }
}
public extension Double {
    /**
    Returns a random floating point number between 0.0 and 1.0, inclusive.
    By DaRkDOG
    */
    public static func random() -> Double {
        return Double(arc4random()) / 0xFFFFFFFF
    }
    
    /**
    Create a random num Double
    :param: lower number Double
    :param: upper number Double
    :return: random number Double
    By DaRkDOG
    */
    public static func random(#min: Double, max: Double) -> Double {
        return Double.random() * (max - min) + min
    }
}

public extension Float {
    /**
    Returns a random floating point number between 0.0 and 1.0, inclusive.
    */
    
    public static func random() -> Float {
        return Float(arc4random()) / 0xFFFFFFFF
    }
    
    /**
    Create a random num Float
    :param: lower number Float
    :param: upper number Float
    :return: random number Float
    */
    public static func random(#min: Float, max: Float) -> Float {
        return Float.random() * (max - min) + min
    }
}

public extension CGFloat {
    /**
    Returns a random floating point number between 0.0 and 1.0, inclusive.
    By DaRkDOG
    */
    public static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    /**
    Create a random num CGFloat
    :param: lower number CGFloat
    :param: upper number CGFloat
    :return: random number CGFloat
    By DaRkDOG
    */
    public static func random(#min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat.random() * (max - min) + min
    }
}