package com.bjpowernode.crm.settings.service.impl;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.mapper.UserMapper;
import com.bjpowernode.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Map;

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
    @Override
    public User querySelectLoginActAndPwd(Map<String, Object> paraMap) {

        return userMapper.selectLoginActAndPwd(paraMap);
    }
}
