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

@main
struct UnderscorerExtension: NamingExtensionCLI {

    static let allowlist: Set<String> = [
        "query",
        "body",
        "headers",
        "path",
        "cookies",
    ]

    func computeName(_ openAPIName: OpenAPIName) async throws -> SwiftName {
        let string = openAPIName.originalName
        if Self.allowlist.contains(string) {
            return .init(computedName: string)
        }
        return .init(computedName: "___" + string)
    }
}
