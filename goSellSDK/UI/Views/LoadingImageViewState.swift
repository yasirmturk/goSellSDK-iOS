//
//  LoadingImageViewState.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Loading image view state.
///
/// - notLoaded: Image loading has not started.
/// - loading: Image is loading.
/// - loaded: Image has loaded.
internal enum LoadingImageViewState {
    
    case notLoaded
    case loading
    case loaded(image: UIImage)
}