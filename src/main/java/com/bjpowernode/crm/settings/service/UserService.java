package com.bjpowernode.crm.settings.service;

import com.bjpowernode.crm.settings.domain.User;

import java.util.List;
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

    /**
     * 根据账号查找信息
     * @param loginAct
     * @return
     */
    User selectLoginAct(String loginAct);

    /**
     * 查询全部所有者信息
     * @return
     */
    List<User> selectUserList();

}
