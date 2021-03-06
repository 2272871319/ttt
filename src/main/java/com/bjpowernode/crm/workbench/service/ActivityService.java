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
     * 创建页面新增数据
     * @return
     */
    int saveCreateActivity(Activity activity);

    /**
     * 编辑页面反显数据
     * @param id
     * @return
     */
    Activity queryActivityKeyById(String id);

    /**
     * 名称详情里面 主键查单个用户
     * @param id
     * @return
     */
    Activity queryActivityKey(String id);

    /**
     * 修改市场活动 编辑页面更新功能
     * @param activity
     * @return
     */
    int saveEditActivity(Activity activity);

    /**
     * 批量删除
     * @param id
     * @return
     */
    int deleteActivity(String[] id);

    /**
     * 导出全部市场活动数据
     * @return
     */
    List<Activity> exportAllActivityList();

    /**
     * 根据id查询
     * @param id
     * @return
     */
    List<Activity> exportActivityXz(String[] id);

    /**
     * 批量导入
     * @param activityList
     * @return
     */
    int saveImportActivityList(List<Activity> activityList);

    List<Activity> queryAllClueActivityRelation(String id);

    /**
     * 关联市场活动查看列表
     * @param map
     * @return
     */
    List<Activity> exportShowConvert(Map<String,Object> map);

    /**
     * 线索转化页面，搜索市场活动的单选框
     * @param map
     * @return
     */
    List<Activity> convertShowConvert(Map<String, Object> map);
}
