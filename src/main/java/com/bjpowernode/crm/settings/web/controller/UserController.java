package com.bjpowernode.crm.settings.web.controller;

import com.bjpowernode.crm.commons.contants.Constants;
import com.bjpowernode.crm.commons.utils.MD5Util;
import com.bjpowernode.crm.commons.utils.Result;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.mapper.UserMapper;
import com.bjpowernode.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * ClassName:
 * Package:com.bjpowernode.crm.settings.web.controller
 * author:郭鑫
 */
@Controller
public class UserController {

    @Autowired
    private UserService userService;

    @RequestMapping("/settings/qx/user/toLogin.do")
    public String toLogin() {
        return "settings/qx/user/login";
    }


    @RequestMapping("/settings/qx/user/login.do")
    public @ResponseBody Object login(HttpServletRequest request, String loginAct, String loginPwd) throws ParseException {
        Map<String,Object> paraMap = new HashMap<>();
        paraMap.put("loginAct",loginAct);
        paraMap.put("loginPwd", MD5Util.getMD5(loginPwd));

        //去数据库查看有么有获取的账号和密码
        User user = userService.querySelectLoginActAndPwd(paraMap);

        //创建一个map集合存储返回的信息
        Map<String,Object> map = new HashMap<>();

        //判断返回的对象为空则密码错误
        if (user == null){
            return Result.fail("账号或密码不匹配");
        }

        //验证账号失效时间
        if (!"".equals(user.getExpireTime())&& new Date().compareTo(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(user.getExpireTime()))>0){
            return Result.fail("账号已失效");
        }

        //判断账号锁定状态lock_state为0 则被锁定
        if (user.getLockState().equals("0")){
            return Result.fail("账号已被锁定，请联系管理员解封");
        }
        //判断账号ip地址
        String localAddr = request.getLocalAddr();
        if (!user.getAllowIps().contains(localAddr)&&!"".equals(user.getAllowIps())){
            return Result.fail("ip不能用");
        }
        //返回的对象
        request.getSession().setAttribute(Constants.SESSION_USER, user);
        //密码正确
        return Result.success();
    }
}
