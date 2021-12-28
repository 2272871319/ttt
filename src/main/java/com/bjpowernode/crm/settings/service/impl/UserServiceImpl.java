package com.bjpowernode.crm.settings.service.impl;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.mapper.UserMapper;
import com.bjpowernode.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.BoundListOperations;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

/**
 * ClassName:UserServiceImpl
 * Package:com.bjpowernode.crm.settings.service.impl
 * Description:
 * author:王
 */
@Service
public class UserServiceImpl implements UserService {
    @Autowired
    UserMapper userMapper;

    @Autowired
    private RedisTemplate redisTemplate;

    @Override
    public User querySelectLoginActAndPwd(Map<String, Object> paraMap) {

        return userMapper.selectLoginActAndPwd(paraMap);
    }

    /**
     * 根据账号查询信息
     * @param loginAct
     * @return
     */

    @Override
    public User selectLoginAct(String loginAct) {
        return userMapper.selectLoginAct(loginAct);
    }

    //查询所有者数据
    @Override
    public List<User> selectUserList() {
        //获取list数据操作对象
        BoundListOperations boundListOperations = redisTemplate.boundListOps("users");

        //从redis缓存获取全部数据
        List<User> userList = boundListOperations.range(0, -1);
        if (userList == null || userList.size() == 0){
            userList = userMapper.selectUserList();
            for (User user : userList) {
                boundListOperations.leftPush(user);
            }

            //设置redis缓存失效时间
            boundListOperations.expire(60*60*24, TimeUnit.SECONDS);
        }

        return userList;
    }
}
