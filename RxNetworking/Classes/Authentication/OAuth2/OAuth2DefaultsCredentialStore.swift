//
//  OAuth2DefaultsCredentialStore.swift
//  RxNetworking
//
//  Created by Bruno Morgado on 20/08/16.
//  Copyright © 2016 KO Computer. All rights reserved.
//

import Foundation

public struct OAuth2DefaultsCredentialStore: CredentialStore {
    let userDefaults: UserDefaults
    
    public init(withUserDefaults userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
    
    public func storeCredential(_ credential: Credential, withIdentifier identifier: String) throws {
        guard let _credential = credential as? OAuth2Credential else {
            throw CredentialStoreError.unknown
        }
        let data = NSKeyedArchiver.archivedData(withRootObject: _credential)
        userDefaults.set(data, forKey: identifier)
    }
    
    public func retrieveCredential(withIdentifier identifier: String) throws -> Credential {
        let data = userDefaults.data(forKey: identifier)
        
        guard let _data = data else {
            throw CredentialStoreError.credentialNotFound
        }
        guard let credential = NSKeyedUnarchiver.unarchiveObject(with: _data) as? OAuth2Credential else {
            throw CredentialStoreError.unableToUnarchive
        }
        
        return credential
    }
    
    public func deleteCredential(withIdentifier identifier: String) throws {
        userDefaults.removeObject(forKey: identifier)
    }
}

