
//
//
//  HMAC.swift
//  hmacTest
//
//  Created by khan on 07/05/2018.
//  Copyright © 2018 khan. All rights reserved.
//

import Foundation

/*
 Usage:
 1. Add an ObjC bridging header.
 2. Import <CommonCrypto/CommonCrypto.h> in the header.
 */


//    kCCHmacAlgSHA1,
//    kCCHmacAlgMD5,
//    kCCHmacAlgSHA256,
//    kCCHmacAlgSHA384,
//    kCCHmacAlgSHA512,
//    kCCHmacAlgSHA224


enum HMACAlgorithm {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    
    func toCCHmacAlgorithm() -> CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:
            result = kCCHmacAlgMD5
        case .SHA1:
            result = kCCHmacAlgSHA1
        case .SHA224:
            result = kCCHmacAlgSHA224
        case .SHA256:
            result = kCCHmacAlgSHA256
        case .SHA384:
            result = kCCHmacAlgSHA384
        case .SHA512:
            result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    
    func digestLength() -> Int {
        var result: CInt = 0
        switch self {
        case .MD5:
            result = CC_MD5_DIGEST_LENGTH
        case .SHA1:
            result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:
            result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:
            result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:
            result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:
            result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}


//enum HmacAlgorithm {
//    case sha1, md5, sha256, sha384, sha512, sha224
//    var algorithm: CCHmacAlgorithm {
//        var alg = 0
//        switch self {
//        case .sha1:
//            alg = kCCHmacAlgSHA1
//        case .md5:
//            alg = kCCHmacAlgMD5
//        case .sha256:
//            alg = kCCHmacAlgSHA256
//        case .sha384:
//            alg = kCCHmacAlgSHA384
//        case .sha512:
//            alg = kCCHmacAlgSHA512
//        case .sha224:
//            alg = kCCHmacAlgSHA224
//        }
//        return CCHmacAlgorithm(alg)
//    }
//    var digestLength: Int {
//        var len: Int32 = 0
//        switch self {
//        case .sha1:
//            len = CC_SHA1_DIGEST_LENGTH
//        case .md5:
//            len = CC_MD5_DIGEST_LENGTH
//        case .sha256:
//            len = CC_SHA256_DIGEST_LENGTH
//        case .sha384:
//            len = CC_SHA384_DIGEST_LENGTH
//        case .sha512:
//            len = CC_SHA512_DIGEST_LENGTH
//        case .sha224:
//            len = CC_SHA224_DIGEST_LENGTH
//        }
//        return Int(len)
//    }
//}
//
extension String {

    func hmac(algorithm: HMACAlgorithm, key: String) -> String {
        let cKey = key.cString(using: String.Encoding.utf8)
        let cData = self.cString(using: String.Encoding.utf8)
        var result = [CUnsignedChar](repeating: 0, count: Int(algorithm.digestLength()))
        let length : Int = Int(strlen(cKey!))
        let data : Int = Int(strlen(cData!))
        CCHmac(algorithm.toCCHmacAlgorithm(), cKey!,length , cData!, data, &result)
        
        let hmacData:NSData = NSData(bytes: result, length: (Int(algorithm.digestLength())))
        
        var bytes = [UInt8](repeating: 0, count: hmacData.length)
        hmacData.getBytes(&bytes, length: hmacData.length)
        
        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02hhx", UInt8(byte))
        }
        return hexString
    }

//    func hmac(algorithm: HmacAlgorithm, key: String) -> String {
//        var digest = [UInt8](repeating: 0, count: algorithm.digestLength)
//        CCHmac(algorithm.algorithm, key, key.count, self, self.count, &digest)
//        let data = Data(bytes: digest)
//        return data.map { String(format: "%02hhx", $0) }.joined()
//    }


}





// The MIT License (MIT)
//
// Copyright (c) 2018 Jernej Strasner
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

//import Foundation
//
//public enum Algorithm {
//    case md5, sha1, sha224, sha256, sha384, sha512
//
//    fileprivate var hmacAlgorithm: CCHmacAlgorithm {
//        var result: Int = 0
//        switch self {
//        case .md5:        result = kCCHmacAlgMD5
//        case .sha1:        result = kCCHmacAlgSHA1
//        case .sha224:    result = kCCHmacAlgSHA224
//        case .sha256:    result = kCCHmacAlgSHA256
//        case .sha384:    result = kCCHmacAlgSHA384
//        case .sha512:    result = kCCHmacAlgSHA512
//        }
//        return CCHmacAlgorithm(result)
//    }
//
//    fileprivate typealias DigestAlgorithm = (UnsafeRawPointer, CC_LONG, UnsafeMutablePointer<UInt8>) -> UnsafeMutablePointer<UInt8>?
//
//    fileprivate var digestAlgorithm: DigestAlgorithm {
//        switch self {
//        case .md5:      return CC_MD5
//        case .sha1:     return CC_SHA1
//        case .sha224:   return CC_SHA224
//        case .sha256:   return CC_SHA256
//        case .sha384:   return CC_SHA384
//        case .sha512:   return CC_SHA512
//        }
//    }
//
//    public var digestLength: Int {
//        var result: Int32 = 0
//        switch self {
//        case .md5:        result = CC_MD5_DIGEST_LENGTH
//        case .sha1:        result = CC_SHA1_DIGEST_LENGTH
//        case .sha224:    result = CC_SHA224_DIGEST_LENGTH
//        case .sha256:    result = CC_SHA256_DIGEST_LENGTH
//        case .sha384:    result = CC_SHA384_DIGEST_LENGTH
//        case .sha512:    result = CC_SHA512_DIGEST_LENGTH
//        }
//        return Int(result)
//    }
//}
//
//public protocol Hashable {
//    associatedtype Hash
//    func digest(_ algorithm: Algorithm, key: String?) -> Hash
//
//    var md5: Hash { get }
//    var sha1: Hash { get }
//    var sha224: Hash { get }
//    var sha256: Hash { get }
//    var sha384: Hash { get }
//    var sha512: Hash { get }
//}
//
//extension Hashable {
//
//    public var md5: Hash {
//        return digest(.md5, key: nil)
//    }
//
//    public var sha1: Hash {
//        return digest(.sha1, key: nil)
//    }
//
//    public var sha224: Hash {
//        return digest(.sha224, key: nil)
//    }
//
//    public var sha256: Hash {
//        return digest(.sha256, key: nil)
//    }
//
//    public var sha384: Hash {
//        return digest(.sha384, key: nil)
//    }
//
//    public var sha512: Hash {
//        return digest(.sha512, key: nil)
//    }
//
//}
//
//extension String: Hashable {
//
//    public func digest(_ algorithm: Algorithm) -> String {
//        return digest(algorithm, key: Optional<Data>.none)
//    }
//
//    public func digest(_ algorithm: Algorithm, key: String?) -> String {
//        return digest(algorithm, key: key?.data(using: .utf8))
//    }
//
//    public func digest(_ algorithm: Algorithm, key: Data?) -> String {
//        let str = Array(self.utf8CString)
//        let strLen = str.count-1
//        let digestLen = algorithm.digestLength
//        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: digestLen)
//
//        if let key = key {
//            key.withUnsafeBytes { body in
//                CCHmac(algorithm.hmacAlgorithm, UnsafeRawPointer(body), key.count, str, count, result)
//            }
//        } else {
//            _ = algorithm.digestAlgorithm(str, CC_LONG(strLen), result)
//        }
//
//        let digest = result.toHexString(count: digestLen)
//
//        result.deallocate()
//
//        return digest
//    }
//}
//
//extension Data: Hashable {
//
//    public func digest(_ algorithm: Algorithm) -> Data {
//        return digest(algorithm, key: Optional<Data>.none)
//    }
//
//    public func digest(_ algorithm: Algorithm, key: String?) -> Data {
//        return digest(algorithm, key: key?.data(using: .utf8))
//    }
//
//    public func digest(_ algorithm: Algorithm, key: Data?) -> Data {
//        let count = self.count
//        let digestLen = algorithm.digestLength
//
//        return self.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> Data in
//            let result = UnsafeMutablePointer<UInt8>.allocate(capacity: digestLen)
//            defer {
//                result.deallocate()
//            }
//
//            if let key = key {
//                key.withUnsafeBytes { body in
//                    CCHmac(algorithm.hmacAlgorithm, UnsafeRawPointer(body), key.count, bytes, count, result)
//                }
//            } else {
//                _ = algorithm.digestAlgorithm(bytes, CC_LONG(count), result)
//            }
//
//            return Data(bytes: result, count: digestLen)
//        }
//    }
//
//}
//
//private extension UnsafeMutablePointer where Pointee == CUnsignedChar {
//
//    func toHexString(count: Int) -> String {
//        var result = String()
//        for i in 0..<count {
//            let s = String(self[i], radix: 16)
//            if s.count % 2 == 1 {
//                result.append("0"+s)
//            } else {
//                result.append(s)
//            }
//        }
//        return result
//    }
//
//}

