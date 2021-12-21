package com.bjpowernode.crm.settings.service;

import com.bjpowernode.crm.settings.domain.User;

import java.util.Map;

/**
 * ClassName:UserService
 * Package:com.bjpowernode.crm.settings.service
 * Description:
 * author:王
 */
public interface UserService {
    /**
     * 查看数据库有没有该用户
     * @param paraMap
     * @return
     */
    User querySelectLoginActAndPwd(Map<String, Object> paraMap);
}
