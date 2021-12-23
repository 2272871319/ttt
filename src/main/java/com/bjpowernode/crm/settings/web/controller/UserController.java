package com.bjpowernode.crm.settings.web.controller;

import com.bjpowernode.crm.commons.contants.Constants;
import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.commons.utils.MD5Util;
import com.bjpowernode.crm.commons.utils.Result;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.mapper.UserMapper;
import com.bjpowernode.crm.settings.service.UserService;
import com.sun.deploy.net.HttpResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.BoundValueOperations;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.serializer.Jackson2JsonRedisSerializer;
import org.springframework.data.redis.serializer.StringRedisSerializer;
import org.springframework.http.HttpRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

/**
 * ClassName:
 * Package:com.bjpowernode.crm.settings.web.controller
 * author:郭鑫
 */
@Controller
public class UserController {

    @Autowired
    private UserService userService;
    @Autowired
    private RedisTemplate redisTemplate;

    @RequestMapping("/settings/qx/user/toLogin.do")
    public String toLogin() {
        return "settings/qx/user/login";
    }


    @RequestMapping("/settings/qx/user/login.do")
    public @ResponseBody Object login(HttpServletResponse response,Boolean isRemPwd, HttpServletRequest request, String loginAct, String loginPwd) throws ParseException {
        //redis所有类序列化
        redisTemplate.setValueSerializer(new Jackson2JsonRedisSerializer<Object>(Object.class));
        //把通过的字符串序列化（Key名简单化）
        redisTemplate.setKeySerializer(new StringRedisSerializer());

        //根据用户名查看账户是否存在
        User userAct = userService.selectLoginAct(loginAct);
        if (userAct == null){
            return Result.fail("账号或密码错误");
        }
        //获取操作指定key的操作对象
        BoundValueOperations boundValueOperations = redisTemplate.boundValueOps(loginAct);

        //从redis查看当前账号是否存在
        Integer o = (Integer) boundValueOperations.get();
        //判断是否为空
        if (o != null && o == 3){
            return Result.fail("当日累计密码错误次数为"+o+"账号已被锁定请联系管理员");
        }else if (o == null){
            o = 0;
        }

        Map<String,Object> paraMap = new HashMap<>();
        paraMap.put("loginAct",loginAct);
        paraMap.put("loginPwd", MD5Util.getMD5(loginPwd));


        //去数据库查看有么有获取的账号和密码
        User user = userService.querySelectLoginActAndPwd(paraMap);

        //创建一个map集合存储返回的信息
       // Map<String,Object> map = new HashMap<>();

        //判断返回的对象为空则密码错误
        if (user == null){
            //如果密码错误则当前账号输错次数+1
            boundValueOperations.increment(1);
            //设置当前key失效时间
            boundValueOperations.expire(DateUtils.getRemainSecondsOneDay(new Date()), TimeUnit.SECONDS);
            return Result.fail("账号或密码不匹配,您还有"+(2-o)+"次机会");
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

        //判断用户是否勾选 记住我
        if (isRemPwd){
            Cookie act = new Cookie("loginAct", loginAct);
            //浏览器记住改密码最大时间
            act.setMaxAge(60*60*24);
            Cookie pwd = new Cookie("loginPwd", loginPwd);
            pwd.setMaxAge(60*60*24);
            response.addCookie(act);
            response.addCookie(pwd);
        }
        //返回的对象
        request.getSession().setAttribute(Constants.SESSION_USER, user);
        //密码正确
        return Result.success();
    }


    @RequestMapping("/settings/qx/user/logout.do")
    public String logout(HttpServletRequest request){
        request.getSession().invalidate();
      //  request.getSession().removeAttribute(Constants.SESSION_USER);
        return "redirect:/";
    }
}
