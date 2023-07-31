//
//  AttributionCLI.swift
//  AttributionKit
//
//  Created by Corey Davis on 7/29/23.
//

import Foundation
import AttributionKit

struct AttributionCLI {
    static private let sourceRoot = ProcessInfo.processInfo.environment["SRCROOT"]
    static private let projectTemp = ProcessInfo.processInfo.environment["PROJECT_TEMP_DIR"]
    static private let attributionsPlist = "Attributions.plist"
    
    static public func main() {
        print("Creating attributions...")
        defer {
            print("Attribution creation complete")
        }
        
        print("Source root: \(String(describing: sourceRoot))")
        print("Project temp directory: \(String(describing: projectTemp))")
        
        guard let path = makePlistPath() else { return }
        var attributions = makePackageAttributions()
        attributions.append(contentsOf: makePodsAttributions())
        save(attributions: attributions, path: path)
    }
}

// MARK: - Package Functions

extension AttributionCLI {
    static func makePackageAttributions() -> [AttributionModel] {
        guard let path = makePackagePath() else { return [] }
        var attributions: [AttributionModel] = []
        do {
            let packages = try FileManager.default.contentsOfDirectory(atPath: path)
            let filteredPackages = packages.filter { $0.prefix(1) != "." }
            for package in filteredPackages {
                print("...\(package)")
                guard let attribution = makeAttribution(package: package, at: path) else { continue }
                attributions.append(attribution)
            }
        } catch {
            printError("Reading contents of \(path): \(error)")
        }
        return attributions
    }
    
    static func makeAttribution(package: String, at path: String) -> AttributionModel? {
        let licensePath = path + "/" + package + "/LICENSE"
        guard
            let data = getLicenseData(for: package, at: licensePath),
            let license = decodeLicense(data, for: package)
        else { return nil }
        return AttributionModel(name: package, license: license)
    }
    
    static private func makePackagePath() -> String? {
        guard let path = projectTemp else {
            printError("Temp directory not available")
            return nil
        }
        return path.components(separatedBy: "/Build/")[0] + "/SourcePackages/checkouts"
    }
}

// MARK: - Pods Functions

extension AttributionCLI {
    static func makePodsAttributions() -> [AttributionModel] {
        let pods = makePodsDirectories()
        return pods.compactMap { pod in
            print(pod)
            return makeAttribution(pod: pod)
        }
    }
    
    static func makeAttribution(pod: String) -> AttributionModel? {
        guard
            let path = makePodsPath(for: pod),
            let data = getLicenseData(for: pod, at: path),
            let license = decodeLicense(data, for: pod)
        else { return nil }
        return AttributionModel(name: pod, license: license)
    }
    
    static private func makePodsPath(for pod: String) -> String? {
        guard let path = sourceRoot else {
            printError("Source directory not available")
            return nil
        }
        return path + "/Pods/" + pod + "/LICENSE"
    }
    
    static private func makePodsDirectories() -> [String] {
        guard let path = sourceRoot else {
            printError("Source directory not available")
            return []
        }
        do {
            let directories = try FileManager.default.contentsOfDirectory(atPath: path + "/Pods")
            print(directories)
            let filtered = directories.filter {
                let ignore = [
                    "Pods.xcodeproj",
                    ".DS_Store",
                    "Target Support Files",
                    "Manifest.lock",
                    "Local Podspecs",
                    "Headers"
                ]
                return !ignore.contains($0)
            }
            return filtered
        } catch {
            printError("Reading contents of \(path): \(error)")
            return []
        }
    }
}

// MARK: - Helpers

extension AttributionCLI {
    static private func printError(_ message: String) {
        print("ATTRIBUTION ERROR: \(message)")
    }
    
    static private func makePlistPath() -> String? {
        guard let path = sourceRoot else {
            printError("Source directory not available")
            return nil
        }
        return path + "/" + attributionsPlist
    }

    static func save(attributions: [AttributionModel], path: String) {
        guard attributions.count > 0 else { return }
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        do {
            let data = try encoder.encode(attributions)
            try data.write(to: URL(fileURLWithPath: path))
        } catch {
            printError("Unable to encode attributions: \(error)")
        }
    }
    
    static func getLicenseData(for dependency: String, at path: String) -> Data? {
        if let data = FileManager.default.contents(atPath: path) {
            return data
        } else if let data = FileManager.default.contents(atPath: path + ".txt") {
            return data
        }
        printError("Unable to get license data for \(dependency) at \(path)")
        return nil
    }
    
    static private func decodeLicense(_ data: Data, for dependency: String) -> String? {
        guard let license = String(data: data, encoding: .utf8) else {
            printError("Unable to convert license data for \(dependency)")
            return nil
        }
        return license
    }
}
