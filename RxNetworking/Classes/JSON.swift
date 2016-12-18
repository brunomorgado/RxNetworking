//
//  JSON.swift
//  RxNetworking
//
//  Created by Bruno Morgado on 20/08/16.
//  Copyright © 2016 KO Computer. All rights reserved.
//

import Foundation

public enum JSONParsingError: Error {
    case invalidJSON
    case fieldNotFound
    case unknown
}

public enum JSONWritingError: Error {
    case unknown
}

public protocol JSONParsableType {
    static func fromJSON(_: AnyObject?, refreshToken: String?) throws -> Self
}

protocol JSONWritableType {
    static func toJSON(_: Self) throws -> AnyObject?
}
