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
}
