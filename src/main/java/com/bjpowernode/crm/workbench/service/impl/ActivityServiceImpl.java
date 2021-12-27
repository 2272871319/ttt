package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.mapper.ActivityMapper;
import com.bjpowernode.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * ClassName:ActivityServiceImpl
 * Package:com.bjpowernode.crm.workbench.service.impl
 * Description:
 * author:王
 */
@Service
public class ActivityServiceImpl implements ActivityService {
    @Autowired
    private ActivityMapper activityMapper;
    @Override
    public List<Activity> selectAllActivityList() {
        return activityMapper.selectAllActivityList();
    }

    @Override
    public Activity queryActivityKey(String id) {
        return activityMapper.selectByPrimaryKey(id);
    }
}
