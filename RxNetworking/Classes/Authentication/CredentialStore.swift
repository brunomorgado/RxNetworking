//
//  CredentialStore.swift
//  RxNetworking
//
//  Created by Bruno Morgado on 14/08/16.
//  Copyright © 2016 KO Computer. All rights reserved.
//

public enum CredentialStoreError: ErrorType {
    case CredentialNotFound
    case UnableToUnarchive
    case Unknown
}

public protocol CredentialStore {
    func storeCredential(credential: Credential, withIdentifier identifier: String) throws
    func retrieveCredential(withIdentifier identifier: String) throws -> Credential
    func deleteCredential(withIdentifier identifier: String) throws
}
