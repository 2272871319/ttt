package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityMapper {
    int deleteByPrimaryKey(String id);

    int insert(Activity record);

    int insertSelective(Activity record);

    Activity selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Activity record);

    int updateByPrimaryKey(Activity record);

    /**
     * 查找全部市场活动
     * @return
     */
    List<Activity> selectAllActivityList(Map<String, Object> paramMap);

    /**
     * 查询返回数据数量
     * @param paramMap
     * @return
     */
    Integer selectAllActivityCount(Map<String, Object> paramMap);

    /**
     * 主键查询 用户详情页面跳转
     * @param id
     * @return
     */
    Activity selectAllPrimaryKey(String id);

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
     * 导出选中的市场活动数据
     * @return
     */
    List<Activity> exportActivityXz(String[] id);
}
