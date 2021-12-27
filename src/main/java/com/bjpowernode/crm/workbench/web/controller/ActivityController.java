package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * ClassName:ActivityController
 * Package:com.bjpowernode.crm.workbench.web.controller
 * Description:市场活动控制层
 * author:王
 */
@Controller
public class ActivityController {

    @Autowired
    private ActivityService activityService;

    /**
     * 市场活动
     * @return
     */
    @RequestMapping("workbench/activity/index.do")
    public String activity(){
        return "workbench/activity/index";
    }

    /**
     * 查看全部市场活动
     * @return
     */
    @RequestMapping("workbench/activity/queryAllActivityList.do")
    @ResponseBody
    public Object queryAllActivityList(){
        List<Activity> activity = activityService.selectAllActivityList();
        return activity;
    }

    /**
     * 用户详情跳转页面
     * @return
     */
    @RequestMapping("workbench/activity/detail.do")
    public String detail(HttpServletRequest request,String id){
        Activity activity = activityService.queryActivityKey(id);
        request.setAttribute("activity", activity);
        return "workbench/activity/detail";
    }
}
