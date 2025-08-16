//
//  MovieDetailsViewModel.swift
//  TEA-Movie-UiKit
//
//  Created by KhaleD HuSsien on 16/08/2025.
//

import UIKit
@MainActor
final class MovieDetailsViewModel{
    // for getting the path of image url for offline mode
     func posterPathFileName(from path: String) -> String {
        let last = (path as NSString).lastPathComponent
        return last.isEmpty ? path.replacingOccurrences(of: "/", with: "_") : last
    }
    func saveImageToDisk(_ image: UIImage, fileName: String) async{
        if let data = image.jpegData(compressionQuality: 0.9) {
            let url = getDocumentsDirectory().appendingPathComponent(fileName)
            try? data.write(to: url)
        }
    }
    
    func loadImageFromDisk(fileName: String) -> UIImage? {
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        return UIImage(contentsOfFile: url.path)
    }
    
     func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
