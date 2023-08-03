//===----------------------------------------------------------------------===//
//
// This source file is part of the SwiftOpenAPIGenerator open source project
//
// Copyright (c) YEARS Apple Inc. and the SwiftOpenAPIGenerator project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of SwiftOpenAPIGenerator project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import OpenAPIGeneratorExtensionsAPI
import Foundation

public protocol NamingExtensionCLI: NamingExtension {
    init()
}

extension NamingExtensionCLI {
    public static func main() async throws {
        let inputData = FileHandle.standardInput.readDataToEndOfFile()
        let input = try JSONDecoder().decode(OpenAPIName.self, from: inputData)
        let output = try await Self.init().computeName(input)
        let outputData = try JSONEncoder().encode(output)
        print(String(decoding: outputData, as: UTF8.self))
    }
}
