//
//  JSON.swift
//  Temp
//
//  Created by Bruno Morgado on 20/08/16.
//  Copyright © 2016 KO Computer. All rights reserved.
//

import Foundation

enum JSONParsingError: ErrorType {
    case InvalidJSON
    case FieldNotFound
    case Unknown
}

enum JSONWritingError: ErrorType {
    case Unknown
}

protocol JSONParsableType {
    static func fromJSON(_: AnyObject?) throws -> Self
}

protocol JSONWritableType {
    static func toJSON(_: Self) throws -> AnyObject?
}
