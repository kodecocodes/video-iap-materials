//
//  Copyright 2017 Lionheart Software LLC
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//

import Foundation

public struct RSAKey {
    var key: SecKey

    public var publicKey: RSAKey? {
        guard let _key = SecKeyCopyPublicKey(key) else {
            return nil
        }

        return RSAKey(key: _key)
    }

    public enum KeyClass {
        case `public`
        case `private`

        var rawValue: CFString {
            switch self {
            case .public: return kSecAttrKeyClassPublic
            case .private: return kSecAttrKeyClassPrivate
            }
        }
    }

    public init() throws {
        let type = kSecAttrKeyTypeRSA
        let attributes: [String: Any] =
            [kSecAttrKeyType as String: type,
             kSecAttrKeySizeInBits as String: 2048
        ]

        var error: Unmanaged<CFError>?
        guard let key = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
            throw error!.takeRetainedValue() as Error
        }

        self.key = key
    }

    public init(key: SecKey) {
        self.key = key
    }

    public init(base64EncodedString string: String, keyClass: KeyClass) throws {
        let keyData = Data(base64Encoded: string)!

        let options: [String: Any] = [kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
                                      kSecAttrKeyClass as String: keyClass.rawValue,
                                      kSecAttrKeySizeInBits as String: 2048]
        var error: Unmanaged<CFError>?
        guard let key = SecKeyCreateWithData(keyData as CFData, options as CFDictionary, &error) else {
            throw error!.takeRetainedValue() as Error
        }

        self.key = key
    }

    public func validateSignature(data: Data, signature: Data, algorithm: SecKeyAlgorithm = .rsaSignatureMessagePKCS1v15SHA256) -> Bool {
        var error: Unmanaged<CFError>?
        guard SecKeyVerifySignature(key, algorithm, data as CFData, signature as CFData, &error) else {
            return false
        }

        return true
    }
}
