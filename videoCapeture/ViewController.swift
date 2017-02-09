//
//  ViewController.swift
//  videoCapeture
//
//  Created by qianjn on 2017/2/8.
//  Copyright © 2017年 SF. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    //输出源的队列
    fileprivate lazy var videoQueue = DispatchQueue.global()
    
    fileprivate lazy var session : AVCaptureSession = AVCaptureSession()
    
    fileprivate lazy var previewLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.session)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let btn = UIButton()
        btn.addTarget(self, action: #selector(ViewController.startCapture), for: .touchUpInside)
        btn.frame = CGRect(x: 100, y: 100, width: 100, height: 50)
        btn.setTitle("start capture", for: .normal)
        btn.backgroundColor = UIColor.gray
        self.view.addSubview(btn)
        
        
        let btn2 = UIButton()
        btn2.addTarget(self, action: #selector(ViewController.stopCapture), for: .touchUpInside)
        btn2.frame = CGRect(x: 100, y: 300, width: 100, height: 50)
        btn2.setTitle("stop capture", for: .normal)
        btn2.backgroundColor = UIColor.gray
        self.view.addSubview(btn2)


        
    }

    func startCapture() {
        // 1. 创建捕捉会话
        //self.session = AVCaptureSession()
        // 2. 给捕捉会话设置输入源（摄像头）
        // 2.1 获取摄像头设备
        guard let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) as? [AVCaptureDevice] else { return }
        
        
        /*
        let devide = devices.filter { (device : AVCaptureDevice) -> Bool in
            return device.position == .front
        }.first
        */
        //简洁写法
        //$0 表示闭包中的第一个参数
        let device = devices.filter({ $0.position == .front}).first
        
        // 2.2  通过device创建AVCaptureInput 对象
        guard let videoInput  = try? AVCaptureDeviceInput(device: device) else {
            return
        }
        session.addInput(videoInput)
        
        // 3. 给捕捉会话设置输出源
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: videoQueue)
        
        session.addOutput(videoOutput)
        // 4. 设置视频预览图层
        
        previewLayer.frame = view.bounds
        view.layer.insertSublayer(previewLayer, at: 0)
        // 5. 开始采集
        session.startRunning()
    }
    
    func stopCapture() {
        session.stopRunning()
        previewLayer.removeFromSuperlayer()
    }

}




extension ViewController : AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        //采集到数据
    }
}
