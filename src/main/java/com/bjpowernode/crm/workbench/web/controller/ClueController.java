package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.commons.contants.Constants;
import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.commons.utils.PaginationVO;
import com.bjpowernode.crm.commons.utils.Result;
import com.bjpowernode.crm.commons.utils.UUIDUtils;
import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.DicValueService;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.*;

/**
 * ClassName:ClueController
 * Package:com.bjpowernode.crm.workbench.web.controller
 * Description:
 * author:王
 */
@Controller
public class ClueController {

    @Autowired
    private ClueService clueService;
    @Autowired
    private DicValueService dicValueService;
    @Autowired
    private UserService userService;
    @Autowired
    private ClueRemarkService clueRemarkService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ClueActivityRelationService clueActivityRelationService;

    @Autowired
    private TranService tranService;
    @Autowired
    private ContactsService contactsService;
    /**
     * 线索
     * @return
     */
    @RequestMapping("workbench/clue/index.do")
    public String clue(){
        return "workbench/clue/index";
    }


    /**
     * 页面导入查询下拉框 线索来源和线索状态
     * @return
     */
    @RequestMapping("workbench/clue/queryAllDicValueSourceAndState.do")
    @ResponseBody
    public Object queryAllDicValueSourceAndState(){
        //获取两种类型的集合
        List<DicValue> sourceList = dicValueService.queryAllDicValueSourceAndState("source");
        List<DicValue> clueStateList = dicValueService.queryAllDicValueSourceAndState("clueState");
        // 装到map返回
        Map<String,Object> map = new HashMap<>();
        map.put("sourceList",sourceList);
        map.put("clueStateList",clueStateList);
        return map;
    }

    /**
     * 多条件分页查询
     * @param fullName
     * @param company
     * @param phone
     * @param source
     * @param owner
     * @param mphone
     * @param state
     * @return
     */
    @RequestMapping("workbench/clue/queryAllByTermClueList.do")
    @ResponseBody
    public Object queryAllByTermClueList(@RequestParam(value = "fullName",required = false)String fullName,
                                         @RequestParam(value = "company",required = false)String company,
                                         @RequestParam(value = "phone",required = false)String phone,
                                         @RequestParam(value = "source",required = false)String source,
                                         @RequestParam(value = "owner",required = false)String owner,
                                         @RequestParam(value = "mphone",required = false)String mphone,
                                         @RequestParam(value = "state",required = false)String state,
                                         @RequestParam(value = "pageNo",required = false)Integer pageNo,
                                         @RequestParam(value = "pageSize",required = false)Integer pageSize){

        Map<String,Object> map = new HashMap<>();
        map.put("fullName",fullName);
        map.put("company", company);
        map.put("phone", phone);
        map.put("source",source );
        map.put("owner", owner);
        map.put("mphone",mphone );
        map.put("state", state);
        map.put("pageNo", (pageNo-1)*pageSize);
        map.put("pageSize", pageSize);

        PaginationVO<Clue> objectPaginationVO = clueService.queryAllByTermClueList(map);

        //返回的总条数除以每页的数量  得到需要展示的页数
        int totalPage = objectPaginationVO.getTotal() / pageSize;
        int mod = objectPaginationVO.getTotal() % pageSize;
        if (mod > 0){
            totalPage += 1;
        }

        Map<String,Object> retMap = new HashMap<>();

        retMap.put("clueList", objectPaginationVO.getDataList());//返回的List集合
        retMap.put("totalPage", totalPage);//页数
        retMap.put("totalRows", objectPaginationVO.getTotal());//总条数
        return retMap;
    }

    /**
     * 创建页面返显 所有者 线索状态来源
     * @return
     */
    @RequestMapping("workbench/clue/createClue.do")
    @ResponseBody
    public Object createClue(){
        List<User> userList = userService.selectUserList();
        List<DicValue> sourceList = dicValueService.queryAllDicValueSourceAndState("source");
        List<DicValue> clueStateList = dicValueService.queryAllDicValueSourceAndState("clueState");
        List<DicValue> appellationList = dicValueService.queryAllDicValueSourceAndState("appellation");

        Map<String,Object> map = new HashMap<>();
        map.put("userList",userList);
        map.put("sourceList",sourceList);
        map.put("clueStateList",clueStateList);
        map.put("appellationList",appellationList);
        return map;
    }

    /**
     * 线索中创建保存数据
     * @param request
     * @param clue
     * @return
     */
    @RequestMapping("workbench/clue/saveCreateClue.do")
    @ResponseBody
    public Object saveCreateClue(HttpServletRequest request,Clue clue){
        User user = (User) request.getSession().getAttribute(Constants.SESSION_USER);

        try {
            clue.setId(UUIDUtils.getUUID());
            clue.setCreateBy(user.getId());
            clue.setCreateTime(DateUtils.formatDateTime(new Date()));
            int count = clueService.saveCreateClue(clue);
            if (count != 1){
                return Result.fail("保存失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.fail("更新失败了");
        }
        return Result.success();
    }

    @RequestMapping("workbench/clue/editClue.do")
    @ResponseBody
    public Object editClue(@RequestParam(value = "id",required = true) String id){

        List<User> userList = userService.selectUserList();
        List<DicValue> sourceList = dicValueService.queryAllDicValueSourceAndState("source");
        List<DicValue> clueStateList = dicValueService.queryAllDicValueSourceAndState("clueState");
        List<DicValue> appellationList = dicValueService.queryAllDicValueSourceAndState("appellation");
        Clue clue = clueService.editClue(id);

        Map<String,Object> map = new HashMap<>();
        map.put("userList",userList);
        map.put("sourceList",sourceList);
        map.put("clueStateList",clueStateList);
        map.put("appellationList",appellationList);
        map.put("clue", clue);

        return map;
    }

    /**
     * 保存更新
     * @return
     */
    @RequestMapping("workbench/clue/saveUpdateClue.do")
    @ResponseBody
    public Object saveUpdateClue(HttpServletRequest request,Clue clue){
        User user = (User) request.getSession().getAttribute(Constants.SESSION_USER);

        try {
            clue.setEditBy(user.getId());
            clue.setEditTime(DateUtils.formatDateTime(new Date()));

            int count = clueService.saveUpdateClue(clue);
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
     * @param id
     * @return
     */
    @RequestMapping("workbench/clue/deleteAll.do")
    @ResponseBody
    public Object deleteAll(String[] id){
        int count=0;
        try {
            count = clueService.deleteAll(id);
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
     *   称呼超链接页面跳转
     */
    @RequestMapping("workbench/clue/detailClue.do")
    public String detailClue(HttpServletRequest request,String id){
        Clue clue = clueService.detailClue(id);
        request.setAttribute("clue", clue);
        return "workbench/clue/detail";
    }

    /**
     * 查询备注列表
     * @param id
     * @return
     */
    @RequestMapping("workbench/clue/detail/queryAllClueRemarkById.do")
    @ResponseBody
    public Object queryAllClueRemarkById(@RequestParam(value = "id",required = true) String id){
        List<ClueRemark> clueRemarks = clueRemarkService.queryAllClueRemarkById(id);
        return clueRemarks;
    }

    /**
     * 备注更新页面保存
     * @param request
     * @param clueRemark
     * @return
     */
    @RequestMapping("workbench/clue/detail/updateRemark.do")
    @ResponseBody
    public Object updateRemark(HttpServletRequest request,ClueRemark clueRemark){
        User user = (User) request.getSession().getAttribute(Constants.SESSION_USER);

        try {
            clueRemark.setEditBy(user.getId());
            clueRemark.setEditTime(DateUtils.formatDateTime(new Date()));

            int count = clueRemarkService.updateRemark(clueRemark);
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
     * 新增备注
     * @param clueRemark
     * @return
     */
    @RequestMapping("workbench/clue/detail/detailRemarkInsert.do")
    @ResponseBody
    public Object detailRemarkInsert(HttpServletRequest request,ClueRemark clueRemark){

        User user = (User) request.getSession().getAttribute(Constants.SESSION_USER);

        try {
            //添加主键 创建者 创建时间
            clueRemark.setId(UUIDUtils.getUUID());
            clueRemark.setCreateBy(user.getId());
            clueRemark.setCreateTime(DateUtils.formatDateTime(new Date()));

            int count = clueRemarkService.saveDetailRemark(clueRemark);
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
     * 删除备注按钮
     * @param id
     * @return
     */
    @RequestMapping("workbench/clue/detail/deleteDiv.do")
    @ResponseBody
    public Object deleteDiv(String id){
        try {
            int count = clueRemarkService.deleteDiv(id);
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
     * 关联市场活动查看列表
     * @return
     */
    @RequestMapping("workbench/clue/detail/showConvert.do")
    @ResponseBody
    public Object showConvert(@RequestParam(value = "clueId",required = false) String clueId,
                              @RequestParam(value = "searchActivityName",required = false) String searchActivityName){
        Map<String,Object> map = new HashMap<>();
        map.put("clueId",clueId);
        map.put("searchActivityName",searchActivityName);
        List<Activity> list = activityService.exportShowConvert(map);
        return list;
    }

    /**
     * 查询全部关联的市场活动
     * @param id
     * @return
     */
    @RequestMapping("workbench/clue/detail/queryAllClueActivityRelation.do")
    @ResponseBody
    public Object queryAllClueActivityRelation(String id){
        List<Activity> activityList = activityService.queryAllClueActivityRelation(id);
        return activityList;
    }

    /**
     * 解除关联
     * @param id
     * @return
     */
    @RequestMapping("workbench/clue/detail/deleteRelation.do")
    @ResponseBody
    public Object deleteRelation(String clueId,String id){
        Map<String,Object> map = new HashMap<>();
        try {
            map.put("clueId", clueId);
            map.put("id", id);

            int count = clueActivityRelationService.deleteRelation(map);
            if (count != 1){
                return Result.fail("解除关联失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.fail("解除关联失败了");
        }
        return Result.success();
    }

    /**
     * 新增关联市场活动
     * @param id
     * @return
     */
    @RequestMapping("workbench/clue/detail/saveBundActivity.do")
    @ResponseBody
    public Object saveBundActivity(@RequestParam(value = "id",required = true) String[] id,
                                   @RequestParam(value = "clueId",required = true)String clueId){

        List<ClueActivityRelation> list = new ArrayList<>();
        ClueActivityRelation clueActivityRelation = null;
        int count = 0;
        try {

            for (String s : id) {
                clueActivityRelation = new ClueActivityRelation();
                clueActivityRelation.setId(UUIDUtils.getUUID());
                clueActivityRelation.setActivityId(s);
                clueActivityRelation.setClueId(clueId);
                list.add(clueActivityRelation);
            }
            count = clueActivityRelationService.saveBundActivity(list);

            if (count == 0){
                return Result.fail("新增失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.fail("新增失败了");
        }
        return Result.success();
    }

    /**
     * 转换按钮跳转页面
     * @return
     */
    @RequestMapping("workbench/clue/convert.do")
    public String convert(HttpServletRequest request,String id){
        //带名称的
        Clue clue = clueService.detailClue(id);

        request.setAttribute("clue", clue);

        return "workbench/clue/convert";
    }

    /**
     * 转换中的阶段下拉框
     * @return
     */
    @RequestMapping("workbench/clue/convert/queryStageByDicValue.do")
    @ResponseBody
    public Object queryStageByDicValue(){
        List<DicValue> dicValueList = dicValueService.queryAllDicValueSourceAndState("stage");
        return dicValueList;
    }

    /**
     * 线索转化页面，搜索市场活动的单选框
     * @param clueId
     * @param searchActivityName
     * @return
     */
    @RequestMapping("workbench/clue/convert/showConvert.do")
    @ResponseBody
    public Object convertShowConvert(@RequestParam(value = "id",required = false) String clueId,
                                     @RequestParam(value = "searchActivityName",required = false) String searchActivityName){
        Map<String,Object> map = new HashMap<>();
        map.put("clueId",clueId);
        map.put("searchActivityName",searchActivityName);
        List<Activity> list = activityService.convertShowConvert(map);
        return list;
    }

    /**
     * 线索转化
     * @param request
     * @param tran
     * @return
     */
    @RequestMapping("workbench/clue/convert/saveConvertByTran.do")
    @ResponseBody
    public Object saveConvertByTran(HttpServletRequest request,Tran tran){

        User user = (User) request.getSession().getAttribute(Constants.SESSION_USER);

        try {
            tran.setId(UUIDUtils.getUUID());
            tran.setCreateBy(user.getId());
            tran.setCreateTime(DateUtils.formatDateTime(new Date()));

            int count = tranService.saveConvertByTran(tran);
            if (count != 1){
                return Result.fail("转化失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.fail("转化失败了");
        }
        return Result.success();
    }
}
