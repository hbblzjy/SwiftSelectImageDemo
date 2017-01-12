//
//  ViewController.swift
//  SwiftSelectImageDemo
//
//  Created by healthmanage on 17/1/12.
//  Copyright © 2017年 healthmanager. All rights reserved.
//选择图片的Demo,类似于ActionSheet的样式

import UIKit
import Photos

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let headBtn = UIButton.init(frame: CGRect.init(x: (UIScreen.main.bounds.size.width-100)/2, y: 100, width: 100, height: 100))
        headBtn.setTitle("更换头像", for: .normal)
        headBtn.backgroundColor = UIColor.lightGray
        headBtn.layer.cornerRadius = 50
        headBtn.clipsToBounds = true
        headBtn.layer.borderColor = UIColor.white.cgColor
        headBtn.layer.borderWidth = 1
        headBtn.addTarget(self, action: #selector(headBtnClick(btn:)), for: .touchUpInside)
        self.view.addSubview(headBtn)
        
    }
    func headBtnClick(btn:UIButton) {
        
        //创建授权状态
        let authorization = PHPhotoLibrary.authorizationStatus()
        
        //如果打开相册授权没有被允许
        if authorization == .notDetermined {
            PHPhotoLibrary.requestAuthorization({ (status) in
                DispatchQueue.main.async(execute: { 
                    let alertV = UIAlertController.init(title: "温馨提示", message: "请打开此APP的相册权限", preferredStyle: .alert)
                    let okAction = UIAlertAction.init(title: "确定", style: .cancel, handler: nil)
                    alertV.addAction(okAction)
                    self.present(alertV, animated: true, completion: nil)
                })
            })
        }else if authorization == .authorized{
            //如果被授权了，弹出图片选择器
            let imgPSVC = ImagePickerSheetController()
            //操作过程就是：如果选择了某张图片，就会触发第二个按钮的显示，然后进行后续图片的显示操作
            //添加第一个操作按钮
            imgPSVC.addAction(ImageAction.init(title: "第一个操作", secondaryTitle: "确定", style: ImageActionStyle.default, handler: { (_) in
                //点击第一个进行的后续操作
                let alertV = UIAlertController.init(title: "温馨提示", message: "点击的是第一个操作", preferredStyle: .alert)
                let okAction = UIAlertAction.init(title: "确定", style: .cancel, handler: nil)
                alertV.addAction(okAction)
                self.present(alertV, animated: true, completion: nil)
                
            }, secondaryHandler: { (action, numberOfPhotos) in
                imgPSVC.getSelectedImagesWithCompletion({ (imageArr) in
                    btn.setImage(imageArr[0], for: .normal)
                })
            }))
            
            //添加第二个操作按钮
            imgPSVC.addAction(ImageAction.init(title: "取消", secondaryTitle: "取消", style: .cancel, handler: nil, secondaryHandler: nil))
            
            present(imgPSVC, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

