package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.workbench.domain.ActivityRemark;
import com.bjpowernode.crm.workbench.mapper.ActivityRemarkMapper;
import com.bjpowernode.crm.workbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * ClassName:ActivityRemarkServiceImpl
 * Package:com.bjpowernode.crm.workbench.service.impl
 * Description:
 * author:王
 */
@Service
public class ActivityRemarkServiceImpl implements ActivityRemarkService {

    @Autowired
    private ActivityRemarkMapper activityRemarkMapper;

    /**
     * 加载备注
     * @param activityId
     * @return
     */
    @Override
    public List<ActivityRemark> queryActivityRemarkListByActivityId(String activityId) {
        return activityRemarkMapper.queryActivityRemarkListByActivityId(activityId);
    }

    /**
     * 保存备注
     * @param remark
     * @return
     */
    @Override
    public int saveCreateRemark(ActivityRemark remark) {
        return activityRemarkMapper.insertSelective(remark);
    }

    @Override
    public int updateRemark(ActivityRemark activityRemark) {
        return activityRemarkMapper.updateByPrimaryKeySelective(activityRemark);
    }

    @Override
    public int deleteDiv(String id) {
        return activityRemarkMapper.deleteByPrimaryKey(id);
    }
}
