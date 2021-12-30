package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.commons.contants.Constants;
import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.commons.utils.PaginationVO;
import com.bjpowernode.crm.commons.utils.Result;
import com.bjpowernode.crm.commons.utils.UUIDUtils;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.ActivityRemark;
import com.bjpowernode.crm.workbench.service.ActivityRemarkService;
import com.bjpowernode.crm.workbench.service.ActivityService;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.net.URLEncoder;
import java.util.*;

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
    @Autowired
    private ActivityRemarkService activityRemarkService;

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
     * 市场活动新增 保存编辑页面的数据
     * @return
     */
    @RequestMapping("workbench/activity/saveCreateActivity.do")
    @ResponseBody
    public Object saveCreateActivity(HttpServletRequest request,Activity activity){
        //拿到登录用户信息
        User sessionUser = (User) request.getSession().getAttribute(Constants.SESSION_USER);
        try {
            //填充id
            activity.setId(UUIDUtils.getUUID());
            //填充创建时间
            activity.setCreateTime(DateUtils.formatDateTime(new Date()));
            //填充修改者id
            activity.setCreateBy(sessionUser.getId());

            int count = activityService.saveCreateActivity(activity);
            if (count != 1){
               return Result.fail("保存失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.fail("保存失败了");
        }
        return Result.success();
    }

    /**
     * 编辑页面返现数据
     * @param id
     * @return
     */
    @RequestMapping("workbench/activity/editActivityModal.do")
    @ResponseBody
    public Object editActivityModal(String id){
        Activity activity = activityService.queryActivityKeyById(id);
        List<User> userList = userService.selectUserList();
        Map<String,Object> map = new HashMap<>();
        map.put("activity",activity);
        map.put("userList",userList);
        return map;
    }

    /**
     * 更新按钮提交数据
     * @param request
     * @param activity
     * @return
     */
    @RequestMapping("workbench/activity/saveEditActivity.do")
    @ResponseBody
    public Object saveEditActivity(HttpServletRequest request,Activity activity){

        User user = (User) request.getSession().getAttribute(Constants.SESSION_USER);
        try {
            activity.setEditTime(DateUtils.formatDateTime(new Date()));
            activity.setEditBy(user.getId());

            int count = activityService.saveEditActivity(activity);
            if (count != 1){
                return Result.fail("更新失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.fail("更新失败了");
        }
        return Result.success();
    }

    /**
     * 批量删除
     * @return
     */
    @RequestMapping("workbench/activity/deleteActivity.do")
    @ResponseBody
    public Object deleteActivity(String[] id){
        int count=0;
        try {
            count = activityService.deleteActivity(id);
            if (count == 0){
                return Result.fail("删除失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.fail("删除失败了");
        }
        return Result.success(count);
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

    /**
     * 加载备注界面
     * @param activityId
     * @return
     */
    @RequestMapping("workbench/activity/queryActivityRemarkListByActivityId.do")
    @ResponseBody
    public Object queryActivityRemarkListByActivityId(@RequestParam(value = "activityId",required = true)String activityId){
        List<ActivityRemark> activityRemarkList = activityRemarkService.queryActivityRemarkListByActivityId(activityId);
        return activityRemarkList;
    }

    /**
     * 保存备注
     * @param request
     * @param remark
     * @return
     */
    @RequestMapping("workbench/activity/saveCreateRemark.do")
    @ResponseBody
    public Object saveCreateRemark(HttpServletRequest request,ActivityRemark remark){
        User user = (User) request.getSession().getAttribute(Constants.SESSION_USER);
        try {
            remark.setId(UUIDUtils.getUUID());//主键id
            remark.setCreateBy(user.getId());//创建者登录账户id
            remark.setCreateTime(DateUtils.formatDateTime(new Date()));//创建时间
            int count = activityRemarkService.saveCreateRemark(remark);
            if (count != 1){
                return Result.fail("保存失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.fail("保存失败了");
        }
        return Result.success();
    }

    /**
     * 修改备注
     * @return
     */
    @RequestMapping("workbench/activity/updateRemark.do")
    @ResponseBody
    public Object updateRemark(HttpServletRequest request,ActivityRemark activityRemark){
        User user = (User) request.getSession().getAttribute(Constants.SESSION_USER);

        try {
            activityRemark.setEditBy(user.getId());
            activityRemark.setEditTime(DateUtils.formatDateTime(new Date()));
            int count = activityRemarkService.updateRemark(activityRemark);
            if (count!=1){
                return Result.fail("更新失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.fail("更新失败了");
        }
        return Result.success();
    }

    /**
     * 备注删除按钮
     * @param id
     * @return
     */
    @RequestMapping("workbench/activity/deleteDiv.do")
    @ResponseBody
    public Object deleteDiv(@RequestParam(value = "id",required = true) String id){
        System.out.println(id);
        try {
            int count = activityRemarkService.deleteDiv(id);
            if (count != 1){
                return Result.fail("删除失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.fail("删除失败了");
        }
        return Result.success();
    }

    /**
     * 导出全部市场活动信息
     */
    @RequestMapping("workbench/activity/exportActivityAll.do")
    public void exportActivityAll(HttpServletResponse response) throws Exception{
        List<Activity> list = activityService.exportAllActivityList();
        //创建工作簿
        HSSFWorkbook workbook = new HSSFWorkbook();
        //创建工作册
        HSSFSheet sheet = workbook.createSheet();
        //创建第一行
        HSSFRow row = sheet.createRow(0);
        //创建第一行的第一列
        HSSFCell cell = row.createCell(0);
        //第一个表格框的内容
        cell.setCellValue("主键ID");
        //第一行的第二列
        cell = row.createCell(1);
        cell.setCellValue("所有者");
        //第一行的第三列
        cell = row.createCell(2);
        cell.setCellValue("市场活动名称");
        //第一行第四列
        cell = row.createCell(3);
        cell.setCellValue("活动开始时间");
        //第一行第五列
        cell = row.createCell(4);
        cell.setCellValue("活动结束时间");
        //第一行第六列
        cell = row.createCell(5);
        cell.setCellValue("成本");
        //第一行第七列
        cell = row.createCell(6);
        cell.setCellValue("内容");
        //第一行第八列
        cell = row.createCell(7);
        cell.setCellValue("创建时间");
        //第一行第九列
        cell = row.createCell(8);
        cell.setCellValue("创建者");
        //第一行第十列
        cell = row.createCell(9);
        cell.setCellValue("修改者");
        //第一行第十一列
        cell = row.createCell(10);
        cell.setCellValue("修改时间");

        //遍历集合对表头下面赋值
        for (int i = 0; i < list.size(); i++) {
            row = sheet.createRow(i + 1);
            cell = row.createCell(0);
            cell.setCellValue(list.get(i).getId());
            cell = row.createCell(1);
            cell.setCellValue(list.get(i).getOwner());
            cell = row.createCell(2);
            cell.setCellValue(list.get(i).getName());
            cell = row.createCell(3);
            cell.setCellValue(list.get(i).getStartDate());
            cell = row.createCell(4);
            cell.setCellValue(list.get(i).getEndDate());
            cell = row.createCell(5);
            cell.setCellValue(list.get(i).getCost());
            cell = row.createCell(6);
            cell.setCellValue(list.get(i).getDescription());
            cell = row.createCell(7);
            cell.setCellValue(list.get(i).getCreateTime());
            cell = row.createCell(8);
            cell.setCellValue(list.get(i).getCreateBy());
            cell = row.createCell(9);
            cell.setCellValue(list.get(i).getEditBy());
            cell = row.createCell(10);
            cell.setCellValue(list.get(i).getEditTime());
        }

        //设置中文下载名称
        String fileName = URLEncoder.encode("市场活动详细列表", "UTF-8");
        //设置响应类型
        response.setContentType("application/octet-stream;charset=UTF-8");
        //设置响应头，下载时以文件附件下载
        response.setHeader("Content-Disposition", "attachment;filename="+fileName+".xls");
        //输出流对象
        ServletOutputStream os = response.getOutputStream();

        workbook.write(os);
        os.flush();
        os.close();
        workbook.close();
    }

    /**
     * 选择导出市场活动信息
     */
    @RequestMapping("workbench/activity/exportActivityXz.do")
    public void exportActivityXz(HttpServletResponse response,String[] id) throws Exception{
        List<Activity> list = activityService.exportActivityXz(id);
        //创建工作簿
        HSSFWorkbook workbook = new HSSFWorkbook();
        //创建工作册
        HSSFSheet sheet = workbook.createSheet();
        //创建第一行
        HSSFRow row = sheet.createRow(0);
        //创建第一行的第一列
        HSSFCell cell = row.createCell(0);
        //第一个表格框的内容
        cell.setCellValue("主键ID");
        //第一行的第二列
        cell = row.createCell(1);
        cell.setCellValue("所有者");
        //第一行的第三列
        cell = row.createCell(2);
        cell.setCellValue("市场活动名称");
        //第一行第四列
        cell = row.createCell(3);
        cell.setCellValue("活动开始时间");
        //第一行第五列
        cell = row.createCell(4);
        cell.setCellValue("活动结束时间");
        //第一行第六列
        cell = row.createCell(5);
        cell.setCellValue("成本");
        //第一行第七列
        cell = row.createCell(6);
        cell.setCellValue("内容");
        //第一行第八列
        cell = row.createCell(7);
        cell.setCellValue("创建时间");
        //第一行第九列
        cell = row.createCell(8);
        cell.setCellValue("创建者");
        //第一行第十列
        cell = row.createCell(9);
        cell.setCellValue("修改者");
        //第一行第十一列
        cell = row.createCell(10);
        cell.setCellValue("修改时间");

        //遍历集合对表头下面赋值
        for (int i = 0; i < list.size(); i++) {
            row = sheet.createRow(i + 1);
            cell = row.createCell(0);
            cell.setCellValue(list.get(i).getId());
            cell = row.createCell(1);
            cell.setCellValue(list.get(i).getOwner());
            cell = row.createCell(2);
            cell.setCellValue(list.get(i).getName());
            cell = row.createCell(3);
            cell.setCellValue(list.get(i).getStartDate());
            cell = row.createCell(4);
            cell.setCellValue(list.get(i).getEndDate());
            cell = row.createCell(5);
            cell.setCellValue(list.get(i).getCost());
            cell = row.createCell(6);
            cell.setCellValue(list.get(i).getDescription());
            cell = row.createCell(7);
            cell.setCellValue(list.get(i).getCreateTime());
            cell = row.createCell(8);
            cell.setCellValue(list.get(i).getCreateBy());
            cell = row.createCell(9);
            cell.setCellValue(list.get(i).getEditBy());
            cell = row.createCell(10);
            cell.setCellValue(list.get(i).getEditTime());
        }

        //设置中文下载名称
        String fileName = URLEncoder.encode("市场活动详细列表", "UTF-8");
        //设置响应类型
        response.setContentType("application/octet-stream;charset=UTF-8");
        //设置响应头，下载时以文件附件下载
        response.setHeader("Content-Disposition", "attachment;filename="+fileName+".xls");
        //输出流对象
        ServletOutputStream os = response.getOutputStream();

        workbook.write(os);
        os.flush();
        os.close();
        workbook.close();
    }
}
