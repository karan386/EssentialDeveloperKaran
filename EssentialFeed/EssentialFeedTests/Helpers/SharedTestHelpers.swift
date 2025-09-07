//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Karan Sawant on 07/09/25.
//

import Foundation

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}
