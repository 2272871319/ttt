package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.ActivityRemark;

import java.util.List;

/**
 * ClassName:ActivityRemarkService
 * Package:com.bjpowernode.crm.workbench.service
 * Description:
 * author:王
 */
public interface ActivityRemarkService {
    /**
     * 加载备注
     * @param activityId
     * @return
     */
    List<ActivityRemark> queryActivityRemarkListByActivityId(String activityId);

    /**
     * 保存备注
     * @param remark
     * @return
     */
    int saveCreateRemark(ActivityRemark remark);

    /**
     * 修改备注
     * @param activityRemark
     * @return
     */
    int updateRemark(ActivityRemark activityRemark);

    /**
     * 备注删除
     * @param id
     * @return
     */
    int deleteDiv(String id);
}
