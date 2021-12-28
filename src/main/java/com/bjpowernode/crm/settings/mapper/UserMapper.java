package com.bjpowernode.crm.settings.mapper;

import com.bjpowernode.crm.settings.domain.User;

import java.util.List;
import java.util.Map;

public interface UserMapper {
    int deleteByPrimaryKey(String id);

    int insert(User record);

    int insertSelective(User record);

    User selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(User record);

    int updateByPrimaryKey(User record);

    /**
     * 根据账户密码查找数据
     * @param paraMap
     * @return
     */
    User selectLoginActAndPwd(Map<String, Object> paraMap);

    /**
     * 根据账号查询用户信息
     * @param loginAct
     * @return
     */
    User selectLoginAct(String loginAct);

    /**
     * 查询全部信息
     * @return
     */
    List<User> selectUserList();
}
