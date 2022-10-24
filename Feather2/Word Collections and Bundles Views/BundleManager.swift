////
////  BundleManager.swift
////  ContextFree
////
////  Created by Charles Diggins on 2/20/22.
////
//
//import Foundation
//import JumpLinguaHelpers
//
//public struct dBundleManager{
//    var m_bundleList = [dBundle]()
//
//    public mutating func appendBundle(bundle: dBundle){
//        m_bundleList.append(bundle)
//    }
//
//    public func getBundle(index: Int)->dBundle{
//        if index >= 0 && index < m_bundleList.count { return m_bundleList[index] }
//        return dBundle()
//    }
//
//    public func getBundleCount()->Int{
//        return m_bundleList.count
//    }
//
//    public mutating func clear(){
//        m_bundleList.removeAll()
//    }
//}
