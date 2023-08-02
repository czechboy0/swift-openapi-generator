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

public struct OpenAPIName: Codable {
    public var originalName: String

    public init(originalName: String) {
        self.originalName = originalName
    }
}

public struct SwiftName: Codable {
    public var computedName: String

    public init(computedName: String) {
        self.computedName = computedName
    }
}

public protocol NamingExtension {
    func computeName(_ openAPIName: OpenAPIName) async throws -> SwiftName
}
