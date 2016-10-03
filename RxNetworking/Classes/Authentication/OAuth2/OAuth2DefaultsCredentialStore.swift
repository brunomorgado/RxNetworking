//
//  OAuth2DefaultsCredentialStore.swift
//  RxNetworking
//
//  Created by Bruno Morgado on 20/08/16.
//  Copyright © 2016 KO Computer. All rights reserved.
//

import Foundation

public struct OAuth2DefaultsCredentialStore: CredentialStore {
    let userDefaults: NSUserDefaults
    
    public init(withUserDefaults userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()) {
        self.userDefaults = userDefaults
    }
    
    public func storeCredential(credential: Credential, withIdentifier identifier: String) throws {
        guard let _credential = credential as? OAuth2Credential else {
            throw CredentialStoreError.Unknown
        }
        let data = NSKeyedArchiver.archivedDataWithRootObject(_credential)
        userDefaults.setObject(data, forKey: identifier)
    }
    
    public func retrieveCredential(withIdentifier identifier: String) throws -> Credential {
        let data = userDefaults.dataForKey(identifier)
        
        guard let _data = data else {
            throw CredentialStoreError.CredentialNotFound
        }
        guard let credential = NSKeyedUnarchiver.unarchiveObjectWithData(_data) as? OAuth2Credential else {
            throw CredentialStoreError.UnableToUnarchive
        }
        
        return credential
    }
    
    public func deleteCredential(withIdentifier identifier: String) throws {
        userDefaults.removeObjectForKey(identifier)
    }
}

