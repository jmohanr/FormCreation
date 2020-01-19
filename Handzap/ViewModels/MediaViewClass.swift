//
//  MediaViewClass.swift
//  Handzap
//
//  Created by Jagan on 19/01/20.
//  Copyright © 2020 Jagan. All rights reserved.
//

import Foundation
import UIKit
enum AttachmentType: String{
    case camera, video, photoLibrary,videoRecord
}
struct ImageConstants {
    static let actionFileTypeHeading = "Add a File..."
    static let actionFileTypeDescription = "Choose a filetype to add..."
    static let camera = "Camera"
    static let phoneLibrary = "Phone Library"
    static let video = "Video"
    static let videoRecord = "Record Video"
    static let VoiceRecord = "Voice Record"
    static let alertForPhotoLibraryMessage = "App does not have access to your photos. To enable access, tap settings and turn on Photo Library Access."
    static let alertForCameraAccessMessage = "App does not have access to your camera. To enable access, tap settings and turn on Camera."
    static let alertForVideoLibraryMessage = "App does not have access to your video. To enable access, tap settings and turn on Video Library Access."
    static let settingsBtnTitle = "Settings"
    static let cancelBtnTitle = "Cancel"
}
extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return self.jpegData(compressionQuality: quality.rawValue)
    }
}
