//
//  Keychain.swift
//  infrareddit
//
//  Created by Benji Tusk on 7/26/22.
//

import Foundation
final class KeychainHelper {
    static let shared = KeychainHelper()
    private init(){}
    
    /// - Parameters:
    ///   - data: the data to store in the Keychain
    ///   - service: A description of what kind of data we are saving, for example: "access-token"
    ///   - account: the 'service' (I know, it's weird), that this data is for, for example, "reddit"
    func save(_ data: Data, service: String, account: String) {
        
        // create query
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
        ] as CFDictionary
        
        // add data in query to keychain
        let status = SecItemAdd(query, nil)
        
        switch status {
        case errSecSuccess:
            // Success! Our work is done.
            return
        case errSecDuplicateItem:
            // The item already exists, let's update it
            let query = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: service,
                kSecAttrAccount: account,
            ] as CFDictionary
            let attributesToUpdate = [kSecValueData: data] as CFDictionary
            
            SecItemUpdate(query, attributesToUpdate)
        default:
            print("\nWARNING: Data not saved to keychain!\n\n")
        }
        
    }
    
    /// - Parameters:
    ///     - service: A description of the data you are accessing. This must be the same string used when saving the data
    ///     - account: The 'service" for which you are fetching data. This must be the same string used when saving the data
    /// - Returns: `Data`, if the read was successful, and `nil`, if it failed
    func read(service: String, account: String) -> Data? {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecValueData: true
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        return (result as? Data)
    }
    
    /// - Parameters:
    ///     - service: A description of the data you are accessing. This must be the same string used when saving the data
    ///     - account: The 'service" for which you are fetching data. This must be the same string used when saving the data
    func delete(service: String, account: String) {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary
        
        // Delete the item
        SecItemDelete(query)
    }
    
    /// - Parameters:
    ///   - item: the item to store in the Keychain. Must conform to `Codable`
    ///   - service: A description of what kind of data we are saving, for example: "access-token"
    ///   - account: the 'service' (I know, it's weird), that this data is for, for example, "reddit"
    func save<T>(_ item: T, service: String, account: String) where T : Codable {
        do {
            // Encode data as JSON and save it in the keychain
            let data = try JSONEncoder().encode(item)
            save(data, service: service, account: account)
        } catch {
            assertionFailure("Failed to encode item for keychain: \(error)")
        }
    }
    
    /// - Parameters:
    ///    - service: A description of the data you are accessing. This must be the same string used when saving the data
    ///    - account: The 'service" for which you are fetching data. This must be the same string used when saving the data
    ///    - type: The Object Type to be returned. `type` must conform to `Codable`
    /// - Returns: `Data`, if the read was successful, and `nil`, if it failed
    func read<T>(service: String, account: String, type: T.Type) -> T? where T : Codable {
        
        // Read item data from keychain
        guard let data = read(service: service, account: account) else {
            return nil
        }
        
        // Decode JSON data to object
        do {
            let item = try JSONDecoder().decode(type, from: data)
            return item
        } catch {
            assertionFailure("Fail to decode item for keychain: \(error)")
            return nil
        }
        
    }
}
