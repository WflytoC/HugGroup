//
//  HGFlags.swift
//  HugGroup
//
//  Created by wcshinestar on 4/11/16.
//  Copyright © 2016 com.onesetp.WflytoC. All rights reserved.
//

import Foundation

struct HGFlags {
    
    //Mark ： 屏幕宽高
    static let kScreenWidth = UIScreen.mainScreen().bounds.width
    static let kScreenHeight = UIScreen.mainScreen().bounds.height
    
    //APIStore 的APPKEY
    
    static let APPStore_Key = "fb9d6aef4ed34b6891cb4c4d1ec0b6c9"
    
    static let smile_url = "http://api.avatardata.cn/Joke/NewstJoke"
    //Video url
    
    static let video_url = "http://www.7791.com.cn/shipin/78"
    //Mark：ShareSDK 
    
    //ShareSDK AppKey
    static let sd_appKey = "117eda11a4b48"
    //ShareSDK AppSecret
    static let sd_appSecret = "6cae5e4db95ce961842c2027e0ac7133"
    
    //RongCloud
    
    //RongCloud APPKey
    static let rc_appKey = "82hegw5uhfj8x"
    //RongCloud APPSecret
    static let rc_appSecret = "klZL6Mm2egdQ"
    
    //Mark : UserDefaults 名称
    
    //判断用户是否登录
    static let ud_isLogin = "com.ccmobile.HugGroup.ud_isLogin"
    //记录登陆用户的手机号
    static let ud_phone = "com.ccmobile.HugGroup.ud_phone"
    //记录用户的token
    static let ud_token = "com.ccmobile.HugGroup.ud_token"
    //记录用户的位置
    static let ud_location = "com.ccmobile.HugGroup.ud_location"
    //记录用户头像URL
    static let ud_portraitUri = "com.ccmobile.HugGroup.ud_portraitUri"
    //记录用户昵称
    static let ud_nickName = "com.ccmobile.HugGroup.ud_nickName"
    //记录用户性别
    static let ud_sex = "com.ccmobile.HugGroup.ud_sex"
    
    //Mark : 请求地址
    
    //用户登录地址
    static let url_userLogin = "http://42.96.204.236/baotuan/index.php?s=Home/User/login"
    //用户注册地址
    static let url_userRegister = "http://42.96.204.236/baotuan/index.php?s=Home/User/register"
    //用户上传头像
    static let url_userUploadIcon = "http://42.96.204.236/baotuan/index.php?s=Home/User/updateportraitUri"
    //用户更新信息
    static let url_userUpdateInfo = "http://42.96.204.236/baotuan/index.php?s=Home/User/updateinfo"
    
    //固定的数据
    //团的分类
    static let groupTypes = ["娱乐八卦","数码科技","美食养生","体育竞技","时尚新潮","家居艺术"]
    
    //Mark:融云即时通讯 URL
    
    static let IM_createGroup = "http://42.96.204.236/baotuan/index.php?s=Home/Group/creategroup"
    
    //Mark: 关于即时通讯的接口
    
    //根据groupid查询团的情况
    static let IM_searchGroup = "http://42.96.204.236/baotuan/index.php?s=Home/Group/searchgroup"
    
    //根据userid查询个人的情况
    static let IM_searchUser = "http://42.96.204.236/baotuan/index.php?s=Home/User/userinfoshow"
    
    //根据团的分类搜索群
    
    static let IM_searchTargets = "http://42.96.204.236/baotuan/index.php?s=Home/Group/classgroup"
    
    //根据关键字搜索团
    
    static let IM_searchGroups = "http://42.96.204.236/baotuan/index.php?s=Home/Group/keywordgroup"
    
    //根据用户ID获取其加入的团的信息
    
    static let IM_joinGroups = "http://42.96.204.236/baotuan/index.php?s=Home/Group/usersearch"
    
    //根据团ID获取所有成员的信息
    static let IM_allUsers = "http://42.96.204.236/baotuan/index.php?s=Home/Group/userlist"
    
    //加团接口
    static let IM_addGroup = "http://42.96.204.236/baotuan/index.php?s=Home/Group/groupjoin"
    
    
    //Mark:qq分享所需信息
    
    static let QQ_APPID = "1105352364"
    
    static let QQ_APPKEY = "Q1lOCwL8Lz1Bfoc3"
    
    //Mark:wechat分享所需信息
    
    static let WeChat_APPID = "wxe6b577a98a121855"
    
    static let WeChat_APPSECRET = "ea734f6c722b087929ed332051dad5a0"
    
    //Mark:ShareSDK的信息
    
    static let SDK_APPKEY = "12032dd447642"
    
    static let SDK_APPSECRET = "d8359fc9384647754b32c2fd6018a21e"

    //HugGroup Schema
    
    static let schema_HugGroup = "HugGroup://ccmobile.com?"
    
    //直播地址
    static let live_url = "rtmp://daniulive.com:1935/hls/stream_huggroup"
    
    static let live_url_try = "rtmp://42.96.204.236/live/"
    
    //控制器间传递的变量
    static let ud_tmp = "com.ccmobile.tmp"
    
    //分享应用
    static let app_url = "https://itunes.apple.com/us/app/huggrouop/id1119180085?l=zh&ls=l&mt=8"
}
