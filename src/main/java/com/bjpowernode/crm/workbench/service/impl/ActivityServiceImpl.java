package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.commons.utils.PaginationVO;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.mapper.ActivityMapper;
import com.bjpowernode.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

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

    /**
     * 多条件分页查询
     * @param paramMap
     * @return
     */
    @Override
    public PaginationVO<Activity> selectAllActivityList(Map<String, Object> paramMap) {
        //创建分页模型对象
        PaginationVO<Activity> listPaginationVO = new PaginationVO<>();
        //返回list集合
        List<Activity> activities = activityMapper.selectAllActivityList(paramMap);
        //放进模型
        listPaginationVO.setDataList(activities);
        Integer i = activityMapper.selectAllActivityCount(paramMap);
        listPaginationVO.setTotal(i);
        return listPaginationVO;
    }

    /**
     * 市场活动页面新增
     * @param activity
     * @return
     */
    @Override
    public int saveCreateActivity(Activity activity) {
        return activityMapper.insertSelective(activity);
    }

    @Override
    public Activity queryActivityKeyById(String id) {
        return activityMapper.selectByPrimaryKey(id);
    }

    /**
     * 用户详情跳转
     * @param id
     * @return
     */
    @Override
    public Activity queryActivityKey(String id) {
        return activityMapper.selectAllPrimaryKey(id);
    }

    /**
     * 修改市场活动 编辑页面更新功能
     * @param activity
     * @return
     */
    @Override
    public int saveEditActivity(Activity activity) {
        return activityMapper.updateByPrimaryKeySelective(activity);
    }

    //批量删除
    @Override
    public int deleteActivity(String[] id) {
        return activityMapper.deleteActivity(id);
    }
    //导出全部市场活动数据

    @Override
    public List<Activity> exportAllActivityList() {
        return activityMapper.exportAllActivityList();
    }

    //导出选中的市场活动数据
    @Override
    public List<Activity> exportActivityXz(String[] id) {
        return activityMapper.exportActivityXz(id);
    }
    //批量导入
    @Override
    public int saveImportActivityList(List<Activity> activityList) {
        return activityMapper.saveImportActivityList(activityList);
    }

    @Override
    public List<Activity> queryAllClueActivityRelation(String id) {
        return activityMapper.queryAllClueActivityRelation(id);
    }

    //关联市场活动查看列表
    @Override
    public List<Activity> exportShowConvert(Map<String,Object> map) {
        return activityMapper.exportShowConvert(map);
    }

    //线索转化页面，搜索市场活动的单选框
    @Override
    public List<Activity> convertShowConvert(Map<String, Object> map) {
        return activityMapper.convertShowConvert(map);
    }
}
