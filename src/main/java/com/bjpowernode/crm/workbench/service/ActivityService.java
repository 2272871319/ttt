package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.commons.utils.PaginationVO;
import com.bjpowernode.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

/**
 * ClassName:ActivityService
 * Package:com.bjpowernode.crm.workbench.service
 * Description:
 * author:王
 */
public interface ActivityService {

    /**
     * 多条件分页查询
     * @return
     */
    PaginationVO<Activity> selectAllActivityList(Map<String, Object> paramMap);

    /**
     * 主键查单个用户
     * @param id
     * @return
     */
    Activity queryActivityKey(String id);
}
