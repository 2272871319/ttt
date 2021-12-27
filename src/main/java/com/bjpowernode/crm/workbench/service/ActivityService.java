package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Activity;

import java.util.List;

/**
 * ClassName:ActivityService
 * Package:com.bjpowernode.crm.workbench.service
 * Description:
 * author:王
 */
public interface ActivityService {

    /**
     * 查看全部市场活动
     * @return
     */
    List<Activity> selectAllActivityList();

    /**
     * 主键查单个用户
     * @param id
     * @return
     */
    Activity queryActivityKey(String id);
}
