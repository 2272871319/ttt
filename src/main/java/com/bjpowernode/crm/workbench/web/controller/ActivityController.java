package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.commons.utils.PaginationVO;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
    @Autowired
    private UserService userService;

    /**
     * 市场活动
     * @return
     */
    @RequestMapping("workbench/activity/index.do")
    public String activity(){
        return "workbench/activity/index";
    }

    /**
     * 多条件分页查询
     * @return
     */
    @RequestMapping("workbench/activity/queryAllActivityList.do")
    @ResponseBody
    public Object queryAllActivityList(@RequestParam(value = "activityName",required = false)String activityName,
                                       @RequestParam(value = "ownerName",required = false)String ownerName,
                                       @RequestParam(value = "StartDate",required = false)String StartDate,
                                       @RequestParam(value = "endDate",required = false)String endDate,
                                       @RequestParam(value = "pageNo",required = true)Integer pageNo,
                                       @RequestParam(value = "pageSize",required = true)Integer pageSize){

        //把参数装进map
        Map<String,Object> paramMap = new HashMap<>();

        paramMap.put("activityName",activityName);
        paramMap.put("ownerName",ownerName);
        paramMap.put("StartDate",StartDate);
        paramMap.put("endDate",endDate);
        paramMap.put("pageNo",(pageNo-1)*pageSize);//页数
        paramMap.put("pageSize",pageSize);//每页显示条数


        //闯将一个分页模型对象 包含两个属性：总记录数  每页显示的数据
        PaginationVO<Activity> paginationVO =  activityService.selectAllActivityList(paramMap);

        int totalPage = paginationVO.getTotal();
        int mod = totalPage / pageSize;
        if (mod>0){
            totalPage = mod+1;
        }

        //map集合存储返回数据
        Map<String,Object> retMap = new HashMap<>();

        retMap.put("activityList", paginationVO.getDataList());
        retMap.put("totalRows", paginationVO.getTotal());
        retMap.put("totalPage",totalPage);

        return retMap;
    }

    /**
     * 创建页面返回所有者信息
     * @return
     */
    @RequestMapping("workbench/activity/createActivityModal.do")
    @ResponseBody
    public Object createActivityModal(){
        List<User> userList = userService.selectUserList();
        return userList;
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
