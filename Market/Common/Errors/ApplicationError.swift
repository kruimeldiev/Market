//
//  ApplicationError.swift
//  Market
//
//  Created by Casper on 12/12/2022.
//

import Foundation

enum ApplicationError: Error {
    
    case genericError
    
    var description: String {
        switch self {
            case .genericError:
                return "An unknown error occured"
        }
    }
}
