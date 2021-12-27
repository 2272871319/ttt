package com.bjpowernode.crm.settings.web.controller;

import com.bjpowernode.crm.commons.contants.Constants;
import com.bjpowernode.crm.commons.utils.Result;
import com.bjpowernode.crm.commons.utils.UUIDUtils;
import com.bjpowernode.crm.settings.domain.DicType;
import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.service.DicTypeService;
import com.bjpowernode.crm.settings.service.DicValueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * ClassName:DicValueController
 * Package:com.bjpowernode.crm.settings.web.controller
 * Description:数据字典值
 * author:王
 */
@Controller
public class DicValueController {

    @Autowired
    private DicValueService dicValueService;

    @RequestMapping("settings/dictionary/value/index.do")
    public String index(){
        return "settings/dictionary/value/index";
    }

    @RequestMapping("settings/dictionary/value/queryAllDicValueList.do")
    @ResponseBody
    public Object queryAllDicValueList(){
       List<DicValue> dicValue = dicValueService.queryAllDicValueList();
       return dicValue;
    }

    @RequestMapping("settings/dictionary/value/createDicValue.do")
    public String createDicValue(){
        return "settings/dictionary/value/save";
    }

    @RequestMapping("settings/dictionary/value/saveCreateDicValue.do")
    @ResponseBody
    public Object saveCreateDicValue(DicValue dicValue){
        try {
            dicValue.setId(UUIDUtils.getUUID());
            int count = dicValueService.saveCreateDicValue(dicValue);
            if (count!=1){
                return Result.fail("添加失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.fail("添加失败");
        }
        return Result.success();
    }

    //接收参数根据主键查询单条数据
    @RequestMapping("settings/dictionary/value/editDicValue.do")
    public String editDicValue(HttpServletRequest request, @RequestParam(value = "id",required = true)String id){

        DicValue dicValue = dicValueService.editDicValue(id);

        request.setAttribute("dicValue", dicValue);

        return "settings/dictionary/value/edit";
    }

    //编辑页面修改数据
    @RequestMapping("settings/dictionary/value/saveEditDicValue.do")
    @ResponseBody
    public Object saveEditDicValue(DicValue dicValue){
        try {

            int count = dicValueService.saveEditDicValue(dicValue);
            System.out.println(count);
            if (count != 1){
                return Result.fail("更新失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            Result.fail("更新失败了");
        }
        return Result.success();
    }

    /**
     * 批量删除
     * @param id
     * @return
     */
    @RequestMapping("settings/dictionary/value/deleteDicValueBtn.do")
    @ResponseBody
    public Object deleteDicValueBtn(String[] id){
        int count=0;
        try {
            count = dicValueService.deleteDicValueBtn(id);
            if (count != id.length){
                Result.fail("删除失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            Result.fail("删除失败了");
        }

        return Result.success(count);
    }

}
