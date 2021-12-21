package com.bjpowernode.crm.settings.web.controller;

import com.bjpowernode.crm.commons.utils.MD5Util;
import com.bjpowernode.crm.settings.mapper.UserMapper;
import org.springframework.http.HttpRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

/**
 * ClassName:
 * Package:com.bjpowernode.crm.settings.web.controller
 * author:郭鑫
 */
@Controller
public class UserController {

    @RequestMapping("/settings/qx/user/toLogin.do")
    public String toLogin() {
        return "settings/qx/user/login";
    }

    @RequestMapping("/settings/qx/user/login.do")
    public @ResponseBody Object login(String loginAct,String loginPwd){
        Map<String,Object> paraMap = new HashMap<>();
        paraMap.put("loginAct",loginAct);
        paraMap.put("loginPwd", MD5Util.getMD5(loginPwd));

        
        return null;
    }
}
