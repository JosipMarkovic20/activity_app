//
//  LoginOutput.swift
//  Activity App
//
//  Created by Josip Marković on 25.06.2021..
//

import Foundation

public struct LoginOutput{
    public var event: LoginOutputEvent?
}

public enum LoginOutputEvent{
    case successfullLogin
    case validationError(error: String?)
}
