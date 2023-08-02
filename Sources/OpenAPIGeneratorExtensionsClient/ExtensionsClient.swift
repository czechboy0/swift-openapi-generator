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

struct ProcessInvocationError: Swift.Error {}

public func InvokeNamingExtension(
    toolPath: URL,
    input: OpenAPIName
) throws -> SwiftName {
    let inputJSON = try JSONEncoder().encode(input)

    let inputPipe = Pipe()
    let outputPipe = Pipe()

    let process = Process()
    process.executableURL = toolPath
    process.environment = [:]
    process.standardInput = inputPipe
    process.standardOutput = outputPipe
    try process.run()

    try inputPipe.fileHandleForWriting.write(contentsOf: inputJSON)
    try inputPipe.fileHandleForWriting.close()

    let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()

    process.waitUntilExit()
    guard process.terminationStatus == 0 else {
        throw ProcessInvocationError()
    }

    return try JSONDecoder().decode(SwiftName.self, from: outputData)
}
