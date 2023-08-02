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

import OpenAPIGeneratorExtensionsCLIProvider
import OpenAPIGeneratorExtensionsAPI

struct UnderscorerExtension: NamingExtension {
    func computeName(_ openAPIName: OpenAPIName) async throws -> SwiftName {
        return .init(computedName: "___" + openAPIName.originalName)
    }
}

@main
struct Tool {
    static func main() async throws {
        try await RegisterCLINamingExtension(UnderscorerExtension())
    }
}
