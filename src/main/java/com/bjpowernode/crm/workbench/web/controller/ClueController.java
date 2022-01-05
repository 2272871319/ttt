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
import com.bjpowernode.crm.workbench.domain.Clue;
import com.bjpowernode.crm.workbench.service.ClueService;
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
    /**
     * 线索
     * @return
     */
    @RequestMapping("workbench/clue/index.do")
    public String clue(){
        return "workbench/clue/index";
    }

    /**
     *   称呼超链接页面跳转
     */
    @RequestMapping("workbench/clue/detailClue.do")
    public String detailClue(){
        return "workbench/clue/detail";
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
}
