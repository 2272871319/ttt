package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.ClueActivityRelation;

import java.util.List;
import java.util.Map;

/**
 * ClassName:ClueActivityRelationService
 * Package:com.bjpowernode.crm.workbench.service
 * Description:
 * author:王
 */
public interface ClueActivityRelationService {
    //解除关联
    int deleteRelation(Map<String, Object> map);

    //新增关联市场活动
    int saveBundActivity(List<ClueActivityRelation> list);
}
